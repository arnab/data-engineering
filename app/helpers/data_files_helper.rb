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
end
