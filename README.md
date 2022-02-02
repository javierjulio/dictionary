# English Dictionary

![Tests](https://github.com/javierjulio/dictionary/workflows/Tests/badge.svg)

This is a minimally tested and incomplete parser of the Webster Unabriged English Dictionary from the [modified GCIDE XML](http://rali.iro.umontreal.ca/GCIDE/) that categorizes content to make it easy to find and parse. I was doing a lot of research on finding a machine readable English dictionary for a project where I didn't want to rely on a third party API (e.g. Wordnik).

## Generate Simple JSON

From the project directory, run the following:

```sh
ruby parse.rb
```

This will generate a JSON file for each GCIDE XML file. Each object key is a unique word and the value being an object containing the definitions (array of objects - definition, part of speech, field, and sequence). The files (excluding obsolete content) will contain ~99k unique words and ~160k definitions.

## Resources

### GCIDE

After reviewing all resources went first with parsing this GCIDE XML. The next best solution seems to be Wikitionary TSV.

* http://rali.iro.umontreal.ca/GCIDE/ (the ZIP download is further down the page)

### Wikitionary TSV

* http://aautar.digital-radiation.com/wiktionary-db/wiktionary.E20121127.tsv.zip
* http://semisignal.com/?p=5666 (TSV file linked to above and sample code)
* https://github.com/boyers/asler/tree/master/scratch

### Webster's Unabridged Dictionary (1913 - public domain)

* http://www.mso.anu.edu.au/~ralph/OPTED/index.html
* https://github.com/janosgyerik/dictgen (Plain Text parser)
* http://en.wiktionary.org/wiki/Wiktionary:Abbreviations_in_Webster

### Moby Word Lists

* https://github.com/drichert/moby (Ruby parser for hyphenation, parts-of-speech, and thesaurus)
