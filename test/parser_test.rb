require 'test_helper'
require 'parser'

# template
# 
# { word: , part_of_speech: , field: , definition: , sequence:  },

class ParserTest < Minitest::Test

  should 'parse single definition' do
    parser = Parser.new(load_fixture('single-definition.xml'))
    
    expected = {
      indiscreet: {
        original_cased_word: 'Indiscreet',
        definitions: [
          {
            part_of_speech: 'adjective', 
            field: '', 
            definition: 'Not discreet; wanting in discretion.', 
            sequence: 1
          }
        ]
      }
    }

    assert_equal parser.parse, expected
  end

  should 'parse multiple same word entries' do
    parser = Parser.new(load_fixture('multiple-same-word-entries.xml'))

    expected = {
      kiss: {
        original_cased_word: 'Kiss',
        definitions: [
          { part_of_speech: 'verb', field: '', definition: 'To salute with the lips, as a mark of affection, reverence, submission, forgiveness, etc.', sequence: 1 },
          { part_of_speech: 'verb', field: '', definition: 'To touch gently, as if fondly or caressingly.', sequence: 2 },
          { part_of_speech: 'verb', field: '', definition: 'To make or give salutation with the lips in token of love, respect, etc.; as, kiss and make friends.', sequence: 1 },
          { part_of_speech: 'verb', field: '', definition: 'To meet; to come in contact; to touch fondly.', sequence: 2 },
          { part_of_speech: 'noun', field: '', definition: 'A salutation with the lips, as a token of affection, respect, etc.; as, a parting kiss; a kiss of reconciliation.', sequence: 1 },
          { part_of_speech: 'noun', field: '', definition: 'A small piece of confectionery.', sequence: 2 }
        ]
      }
    }

    assert_equal parser.parse, expected
  end

  should 'parse multiple definitions at entry root' do
    parser = Parser.new(load_fixture('multiple-entry-root-definitions.xml'))
    
    expected = {
      dactyliography: {
        original_cased_word: 'Dactyliography',
        definitions: [
          { part_of_speech: 'noun', field: 'Fine Arts', definition: 'The art of writing or engraving upon gems.', sequence: 1 },
          { part_of_speech: 'noun', field: 'Fine Arts', definition: 'In general, the literature or history of the art.', sequence: 2 }, 
        ]
      }
    }
    
    assert_equal parser.parse, expected
  end

  should 'parse definitions at different levels' do
    parser = Parser.new(load_fixture('multi-level-definitions.xml'))

    expected = {
      hiss: {
        original_cased_word: 'Hiss',
        definitions: [
          { part_of_speech: 'verb', field: '', definition: 'To make with the mouth a prolonged sound like that of the letter s, by driving the breath between the tongue and the teeth; to make with the mouth a sound like that made by a goose or a snake when angered; esp., to make such a sound as an expression of hatred, passion, or disapproval.', sequence: 1 },
          { part_of_speech: 'verb', field: '', definition: 'To make a similar noise by any means; to pass with a sibilant sound; as, the arrow hissed as it flew.', sequence: 2 },
          { part_of_speech: 'verb', field: '', definition: 'To condemn or express contempt for by hissing.', sequence: 1 },
          { part_of_speech: 'verb', field: '', definition: 'To utter with a hissing sound.', sequence: 2 },
          { part_of_speech: 'noun', field: '', definition: 'A prolonged sound like that letter s, made by forcing out the breath between the tongue and teeth, esp. as a token of disapprobation or contempt.', sequence: 1 },
          { part_of_speech: 'noun', field: '', definition: 'Any sound resembling that above described', sequence: 2 },
          { part_of_speech: 'noun', field: '', definition: 'The noise made by a serpent.', sequence: 3 },
          { part_of_speech: 'noun', field: '', definition: 'The note of a goose when irritated.', sequence: 4 },
          { part_of_speech: 'noun', field: '', definition: 'The noise made by steam escaping through a narrow orifice, or by water falling on a hot stove.', sequence: 5 }
        ]
      }
    }
    
    assert_equal parser.parse, expected
  end

  should 'include specialization fields' do
    parser = Parser.new(load_fixture('definitions-with-specialization-fields.xml'))

    expected = {
      hirundo: {
        original_cased_word: 'Hirundo',
        definitions: [
          { part_of_speech: 'noun', field: 'Zoöl', definition: 'A genus of birds including the swallows and martins.', sequence: 1 }
        ]
      },
      hispid: {
        original_cased_word: 'Hispid',
        definitions: [
          { part_of_speech: 'adjective', field: '', definition: 'Rough with bristles or minute spines.', sequence: 1 },
          { part_of_speech: 'adjective', field: 'Bot. & Zoöl', definition: 'Beset with stiff hairs or bristles.', sequence: 2 }
        ]
      }
    }
    
    assert_equal parser.parse, expected
  end

end
