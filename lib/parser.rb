require 'nokogiri'
require 'active_support/inflector'

class Parser

  PARTS_OF_SPEECH = [
    {label: 'noun', regex: /(?<=^|\s|\.)n\./},
    {label: 'verb', regex: /(?<=^|\s|\.)v\./},
    {label: 'adjective', regex: /(?<=^|\s|\.)a(dj)?\./ },
    {label: 'adverb', regex: /(?<=^|\s|\.)adv\./},
    {label: 'conjunction', regex: /(?<=^|\s|\.)conj\./},
    {label: 'preposition', regex: /(?<=^|\s|\.)prep\./},
    {label: 'interjection', regex: /(?<=^|\s|\.)interj\./},
    {label: 'pronoun', regex: /(?<=^|\s|\.)pron\./}
  ]

  def initialize(contents)
    xml = Nokogiri::XML(contents)
    @entries = xml.xpath("//entry")
  end

  def unabbreviate_part_of_speech(text)
    PARTS_OF_SPEECH.each do |part|
      return part[:label] if text.match(part[:regex])
    end
    ''
  end

  def transliterate(string)
    ActiveSupport::Inflector.transliterate(string)
  end

  def clean_inner_whitespace(string)
    string
      .gsub(/\s{0,}\n{1,}\s{0,}(?![A-Za-z0-9])/, '')  # "test \n   . Test" -> "test. Test"
      .gsub(/\s{0,}\n{1,}\s{0,}(?=[A-Za-z0-9])/, ' ') # "test \ntest" -> "test test"
  end

  def parse
    result = Hash.new { |hash, key| hash[key] = { original_cased_word: '', transliterated_word: '', definitions: [] } }
    
    @entries.each do |entry|
      parse_entry(entry, result)
    end

    result
  end

  def parse_entry(entry, result)
    return if entry.xpath('./mark[1]').text.match(/(?<=^|\s|\.)Obs$/) # Obsolete
    
    original_cased_word = entry.attr('key').strip
    word = original_cased_word.downcase
    
    result[word][:original_cased_word] = original_cased_word
    result[word][:transliterated_word] = transliterate(word)
    
    part_of_speech = unabbreviate_part_of_speech(entry.xpath('./pos[1]').text.strip)
    field = clean_inner_whitespace(entry.xpath('./fld[1]').text.strip)
    sequence = 0
    
    definitions = entry.xpath('./def').map { |d| d.text.strip }.delete_if { |d| d.empty? }
    
    definitions.each_with_index do |definition, index|
      sequence = sequence + 1
      result[word][:definitions] << {
        part_of_speech: part_of_speech,
        field: field,
        definition: clean_inner_whitespace(definition),
        sequence: sequence
      }
    end

    definition_groups = entry.xpath('./sn')
    
    definition_groups.each do |definition_group|
      
      next if definition_group.xpath('./mark[1]').text.match(/(?<=^|\s|\.)Obs$/) # Obsolete
      
      field = definition_group.xpath('./fld[1]').text.strip
      all_sub_definitions = definition_group.xpath('.//def').map { |d| d.text.strip }.delete_if { |d| d.empty? }
      
      all_sub_definitions.each do |definition|
        sequence = sequence + 1
        
        result[word][:definitions] << {
          part_of_speech: part_of_speech,
          field: field,
          definition: clean_inner_whitespace(definition),
          sequence: sequence
        }
      end
    end
  end

end
