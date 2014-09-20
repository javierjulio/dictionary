# English Dictionary

A tested and functional parser of the Webster Unabriged English Dictionary from the [modified GCIDE XML](http://rali.iro.umontreal.ca/GCIDE/) that does the best job of categorizing content to make it easy to find and parse. I did a lot of research on finding a machine readable English dictionary for a word app project I'm working on where we'd like to own the content rather than rely on a third party API (e.g. Wordnik). Plenty of content and resources available which I've listed below.

## Generate Simple JSON

From the project directory run the following command:

```bash
cd dictionary
ruby parse.rb
```

Will generate a JSON file for each GCIDE XML file. The format is a JSON object with each key being a unique word and the value being an object containing the definitions (array of objects - definition, part of speech, field, and sequence). The JSON files total (excluding anything marked as Obs. - Obsolete) will contain 99030 unique words and 159595 definitions.

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
