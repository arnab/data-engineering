module DataFilesHelper
  def example_input_file_link
   'https://raw.github.com/lschallenges/data-engineering/master/example_input.tab'
  end

  def data_file_label_content_with_link
   raw(
    "Please upload a tab-delimited file, like " +
      "<a href='#{example_input_file_link}'>this</a>."
  )
  end

  def purchases_grouped_by_deals(imported_data_file)
    imported_data_file.purchases.group_by(&:deal)
  end

  def purchases_total(purchases)
    total = purchases.inject(0) do |total, p|
      total += (p.quantity * p.deal.price)
    end
    number_to_currency(total)
  end
end
