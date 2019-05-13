# Generated by hyrax:models:install
class FileSet < ActiveFedora::Base
  include ::Hyrax::FileSetBehavior

  # FIXME: find a more appropriate file use?
  directly_contains_one :transcript, through: :files, type: ::RDF::URI('http://pcdm.org/use#Transcript'), class_name: 'Hydra::PCDM::File'

  self.indexer = ESSI::FileSetIndexer

  def ocr_language
    [language.entries,
     parent&.language&.entries,
     ESSI.config.dig(:essi, :hocr_language),
     'eng'].map { |l| Tesseract.try_languages(l) }.select(&:present?).first
  end
end
