import json
import os

import argparse

def main():
    parser = argparse.ArgumentParser()

    parser.add_argument("--input",
                        default="",
                        type=str,
                        required=True,
                        help="File path to a text file to be read")

    parser.add_argument("--output",
                        default="",
                        type=str,
                        required=True,
                        help="File path to a JSON file to be output")
    
    parser.add_argument("--lang",
                        default="",
                        type=str,
                        required=True,
                        help="Language code {ja, zh, nl, fi, fr, de, ru}")

    parser.add_argument("--type",
                        default="",
                        type=str,
                        required=True,
                        help="Translation text type {source, target, translation}")

    parser.add_argument("--split",
                        default="",
                        type=str,
                        required=False,
                        help="Data split {train, dev, test}")
    
    args = parser.parse_args()

    input_name = args.input
    assert os.path.exists(input_name)

    output_name = args.output
    assert not os.path.exists(output_name)
    
    lang = args.lang
    assert lang in {'ja', 'zh', 'nl', 'fi', 'fr', 'de', 'ru'}
    
    type = args.type
    assert type in {'source', 'target', 'translation'}

    split = args.split
    assert split in {'train', 'dev', 'test'}
    
    id = 'salesforce_localization_xml_mt:en{}_{}_{:0=10}'

    jsn = {'lang': ('en' if type == 'source' else lang),
           'type': type,
           'text': {}}

    index = 0
    for line in open(input_name, 'r'):
        line = line.strip()
        jsn['text'][id.format(lang, split, index+1)] = line

        index += 1

    json.dump(jsn, open(output_name, 'w', encoding='utf8'), indent=4, ensure_ascii=False)

if __name__ == '__main__':
    main()
