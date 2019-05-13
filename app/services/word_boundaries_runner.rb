class WordBoundariesRunner < Hydra::Derivatives::Runner

  # Facilitate storing the output as :transcript
  def self.output_file_service
    @output_file_service || PersistDirectlyContainedOutputFileService
  end

  # source file from specified use
  def self.source_file_service
    @source_file_service || Hydra::Derivatives::RetrieveSourceFileService
  end

  def self.processor_class
    Processors::WordBoundaries
  end
end
