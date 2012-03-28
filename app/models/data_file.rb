require 'active_model'
require 'csv'

class DataFile
  include ActiveModel::Conversion
  include ActiveModel::Validations
  include ActiveModel::MassAssignmentSecurity

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

  # Since this model is never persisted, we keep a ref of the objects we do save in here, so we can
  # show something useful on successful saves.
  attr_accessor :data, :deals, :purchases, :allow_duplicate
  attr_accessible :data, :allow_duplicate

  def initialize(attributes = {})
    if attributes.present?
      @allow_duplicate = attributes[:allow_duplicate]
      parse_contents_of!(attributes[:data])
    end
  end

  def persisted?
    # DataFiles are never persisted to the DB, as is
    # @see #import
    false
  end

  # These are the headers we are looking for. This, combined with a lambda we use in parsing the file
  # (@see #initialize) let's the user have the fields in any order in the file.
  HEADER_MAPPINGS ={
    'purchaser name'   => 'purchaser_name',
    'item description' => 'description',
    'item price'       => 'price',
    'purchase count'   => 'quantity',
    'merchant address' => 'merchant_address',
    'merchant name'    => 'merchant_name'
  }

  def header_converter
    lambda { |h| HEADER_MAPPINGS[h].to_sym rescue h.to_sym }
  end

  def parse_contents_of!(uploaded_file)
    contents = uploaded_file.present? ? uploaded_file.read : ""
    @data = CSV.parse(
      contents,
      col_sep: "\t",
      headers: :first_row, return_headers: false, header_converters: header_converter,
      converters: :all
    )
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
      purchase.allow_duplicate = @allow_duplicate
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
      if save_results.all?
        true
      else
        raise ActiveRecord::Rollback# Not all were saved successfully
      end
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
