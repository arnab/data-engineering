require 'active_model'
require 'csv'

class DataFile
  include ActiveModel::Conversion
  include ActiveModel::Validations

  class LineFormatValidator < ActiveModel::Validator
    def validate(record)
      return if record.data.blank?

      record.data.each_with_index do |row, i|
        line_num = i + 1 # 0-based indexes
        row.delete_if { |column_name, val| val.nil? }

        # We need 6 columns per row
        if row.size != 6
          msg = "has #{row.size} fields instead of the required 6"
          record.errors.add :base, "Line #{line_num} #{msg}: #{row.to_s}"
        end
      end
    end
  end

  class PurchasesAndDealsValidator < ActiveModel::Validator
    def validate(record)
      record.parse_purchases_and_deals!
      [record.deals, record.purchases].flatten.each do |thing|
        record.add_error_to_base_for(thing) unless thing.valid?
      end
    end
  end

  validates :data, presence: true
  validates_with LineFormatValidator
  validates_with PurchasesAndDealsValidator

  attr_accessor :data, :deals, :purchases

  HEADER_MAPPINGS ={
    'purchaser name'   => 'purchaser_name',
    'item description' => 'description',
    'item price'       => 'price',
    'purchase count'   => 'quantity',
    'merchant address' => 'merchant_address',
    'merchant name'    => 'merchant_name'
  }

  def initialize(attributes = {})
    if attributes.present?
      file = attributes[:data]
      contents = file.present? ? file.read : ""
      header_converter = lambda { |h| HEADER_MAPPINGS[h].to_sym rescue h }
      @data = CSV.parse(
        contents,
        col_sep: "\t",
        headers: :first_row, return_headers: false, header_converters: header_converter,
        converters: :all
      )
    end
  end

  def persisted?
    # DataFiles are never persisted to the DB, as is
    # @see #import
    false
  end

  def parse_purchases_and_deals!
    @deals, @purchases = [], []

    (@data || []).each_with_index do |data_row, i|
      data = data_row.to_hash
      deal_data, purchase_data = data.dup, data.dup
      deal_data.delete_if     {|k,v| ! Deal.attribute_names.include? k.to_s}
      purchase_data.delete_if {|k,v| ! Purchase.attribute_names.include? k.to_s}

      deal = find_or_initialize_deal_by(deal_data)
      purchase = Purchase.new(purchase_data)
      [deal, purchase].each { |thing| thing.line_num = i + 1}
      deal.purchases << purchase

      @deals     << deal
      @purchases << purchase
    end
  end

  # Save all the objects. They are already validated, but something could have changed between the
  # validation runs and now. So see if they save and rollback if not all of them are saved (avoid partial
  # file uploads)
  def import
    ActiveRecord::Base.transaction do
      save_results = [@deals, @purchases].flatten.map do |thing|
        saved = thing.save
        add_error_to_base_for(thing) unless saved
        saved
      end
      raise ActiveRecord::Rollback unless save_results.all? # Not all were saved successfully
    end
  end

  # A convenience method to transfer the error messages from the AR objects that this is object is
  # composed of. Used to show validation errors for purchases and deals together in the DataFile#create
  # process.
  def add_error_to_base_for(object)
    msg = "Line #{object.line_num}: #{object.errors.full_messages.join(', ')}"
    errors.add :base, msg
  end

  private
    # It's highly likely that an uploaded file has a lot of lines (by purchaser) for the same deal.
    # We don't want to create multiple deals for those, but want to de-dupe.
    # Also, remember may just be in-memory and not persisted yet.
    def find_or_initialize_deal_by(data)
      # First look in the DB
      deal = Deal.where(data).first

      unless deal
        # Next look in the in-memory store
        deal = @deals.find {|in_memory_deal| in_memory_deal.attributes == Deal.new(data).attributes}
      end

      unless deal
        # Ok, init it since we could not find it
        deal = Deal.new(data)
      end

      deal
    end
end
