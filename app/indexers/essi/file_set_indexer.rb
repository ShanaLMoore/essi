module ESSI
  class FileSetIndexer < Hyrax::FileSetIndexer
    include ESSI::IIIFThumbnailBehavior

    def generate_solr_document
      super.tap do |solr_doc|
        solr_doc['is_page_of_ssi'] = object.parent.id if object.parent
        solr_doc['text_timv'] = object.extracted_text.content if object.extracted_text.present?
      end
    end

  end
end

