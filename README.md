# A High-Quality Multilingual Dataset for Structured Documentation Translation

Kazuma Hashimoto, Raffaella Buschiazzo, James Bradbury, Teresa Marshall, Richard Socher, and Caiming Xiong <br>
<a href="https://www.aclweb.org/anthology/W19-5212/">WMT 2019</a>

## 1. Overview

### 1.1 Goal
This project aims at <b>improving the use of machine translation for localization industry</b>.
Machine translation research has a very long history, but in the research community, many of the public research papers are focusing on translation of plain text.
However, these days massive amount of text exists on the Web, and the Web text is usually stored as structured data like HTML or XML files to embed useful information such as <a href="https://www.aclweb.org/anthology/W19-5212/">hyperlinks</a>.
By releasing our high-quality dataset for structured documentation translation, we would like to make it possible for the research community to share knowledge about how to efficiently and accurately translate such rich-formatted text.

### 1.2 High quality
Our datase is constructed directly from real <a href="https://help.salesforce.com/articleView?id=email_unresolved.htm&type=5">Salesforce online help</a>, which covers <b>multiple languages</b> and is <b>maintained by human professionals</b>.
Most of the existing machine translation datasets are constructed by Web crawling and statistical alignments, but our dataset is based on our internal accurately-aligned parallel XML files.

### 1.3 What is the task?
A source string in English in our dataset can contain HTML/XML tags, and our translation task requires a translation system to translate it into another language by preserving the HTML/XML structure.
For example, in <a href="https://www.aclweb.org/anthology/W19-5212/">our paper</a>, we presented a baseline system with a transformer model and a structure-constrained beam search.



## 2. Getting Started

git clone this repository.

### 2.1 Dataset format

All the train/dev/test data are stored in the consistent JSON file format.
We can see the list of the directories as follows:

```bash
$ ls ./data/
ende  enfi  enfr  enja  ennl  enru  enzh
```

Here we can see the seven English-to-<it>X</it> language pairs used on our experiments in <a href="https://www.aclweb.org/anthology/W19-5212/">our paper</a>, and we will add more language pairs later.
We take the English-to-Japanese data for example.

```bash
$ ls ./data/enja/
enja_en_dev.json  enja_en_test.json  enja_en_train.json  enja_ja_dev.json  enja_ja_train.json
```

First, the training data look like this:

```bash
$ cat ./data/enja/enja_en_train.json
{
    "lang": "en",
    "type": "source",
    "text": {
        "salesforce_localization_xml_mt:enja_train_0000000001": "If Email to Salesforce matches an email address to multiple lead or contact records in <ph>Salesforce</ph>, you can associate the email with all matching records, the oldest record, or the record with the most activity.",
        "salesforce_localization_xml_mt:enja_train_0000000002": "You’ve run through the Post-Migration Checklist.",
        "salesforce_localization_xml_mt:enja_train_0000000003": "After you request trial cache, you receive emails at the following intervals.",
        "salesforce_localization_xml_mt:enja_train_0000000004": "Click the email address in this field to send an email using your personal email application. If the <ph>Gmail Buttons and Links</ph> feature is enabled, you can click the Gmail link next to the field to send an email from your Gmail account. See <xref>GmailTM in Salesforce</xref> for more information.",
        "salesforce_localization_xml_mt:enja_train_0000000005": "If the file originated in Salesforce CRM Content, click <uicontrol>Go to Content Detail Page</uicontrol> to see the <xref>content detail page</xref> of that file. Most actions performed on files that originated in Salesforce CRM Content must be done on the file's <xref>content detail page</xref> instead of the file detail page.",
     ...
```

```bash
$ cat ./data/enja/enja_ja_train.json
{
    "lang": "ja",
    "type": "target",
    "text": {
        "salesforce_localization_xml_mt:enja_train_0000000001": "[メール to Salesforce] でメールアドレスが <ph>Salesforce</ph> の複数のリードまたは取引先責任者レコードと一致する場合は、そのメールを、一致するすべてのレコード、最も古いレコード、活動が最も多いレコードのいずれかに関連付けることができます。",
        "salesforce_localization_xml_mt:enja_train_0000000002": "移行後のチェックリストを確認した。",
        "salesforce_localization_xml_mt:enja_train_0000000003": "トライアルキャッシュを要求した後に、次のタイミングでメールが送信されます。",
        "salesforce_localization_xml_mt:enja_train_0000000004": "この項目のメールアドレスをクリックすると、ユーザの個人用メールアプリケーションを使用してメールが送信されます。<ph>Gmail ボタンとリンク</ph>機能が有効な場合、項目の横にある Gmail リンクをクリックして、Gmail アカウントからメールを送信できます。詳細は、<xref>「Salesforce での GmailTM」</xref>を参照してください。",
        "salesforce_localization_xml_mt:enja_train_0000000005": "Salesforce CRM Content で作成されたファイルの場合は、<uicontrol>[コンテンツ詳細ページに移動]</uicontrol> をクリックして、そのファイルの<xref>コンテンツの詳細の表示と編集</xref>を表示する。Salesforce CRM Content で作成されたファイルに対して行う大部分の操作は、ファイル詳細ページではなく、そのファイルの<xref>コンテンツ詳細ページ</xref>で行う必要があります。",
     ...
```

, where we can see the three main fields: "lang", "type", and "text."
A "<b>lang</b>" field represents a language code; for example, here it is either "en" (English) or "ja" (Japanese).
A "<b>type</b>" field defines the type of the text file, and its value is "source," "target," or "translation."
In our primary purpose, "source" always corresponds to English, and "target" corresponds to a target language.
An example of "translation" will be shown later.
A "<b>text</b>" field contains actual text data, where each translatable string has its unique ID like "salesforce_localization_xml_mt:enja_train_0000000001" and the ID is used to identify its paired string in the "source," "target," and "translation" files.
<br><br>
Next, we look into the development data:

```bash
$ cat ./data/enja/enja_en_dev.json
{
    "lang": "en",
    "type": "source",
    "text": {
        "salesforce_localization_xml_mt:enja_dev_0000000001": "External Styles",
        "salesforce_localization_xml_mt:enja_dev_0000000002": "To show the available values, leave the <uicontrol>Search for values...</uicontrol> box empty and click <uicontrol>Search</uicontrol>.",
        "salesforce_localization_xml_mt:enja_dev_0000000003": "assign console layouts to profiles",
        "salesforce_localization_xml_mt:enja_dev_0000000004": "This menu, with shortcuts to various app and object customization features, is available in Salesforce Classic only.",
        "salesforce_localization_xml_mt:enja_dev_0000000005": "To create and share report folders:",
     ...
```

```bash
$ cat ./data/enja/enja_ja_dev.json
{
    "lang": "ja",
    "type": "target",
    "text": {
        "salesforce_localization_xml_mt:enja_dev_0000000001": "外部スタイル",
        "salesforce_localization_xml_mt:enja_dev_0000000002": "選択可能な値を表示するには、<uicontrol>[値を検索...]</uicontrol> ボックスを空のままにして、<uicontrol>[検索]</uicontrol> をクリックします。",
        "salesforce_localization_xml_mt:enja_dev_0000000003": "コンソールレイアウトをプロファイルに割り当て",
        "salesforce_localization_xml_mt:enja_dev_0000000004": "さまざまなアプリケーションやオブジェクトのカスタマイズ機能へのショートカットがあるこのメニューは、Salesforce Classic でのみ使用できます。",
        "salesforce_localization_xml_mt:enja_dev_0000000005": "レポートフォルダを作成および共有する",
     ...
```

```bash
$ cat ./examples/enja_translation.json
{
    "lang": "ja",
    "type": "translation",
    "text": {
        "salesforce_localization_xml_mt:enja_dev_0000000001": " 外部スタイル",
        "salesforce_localization_xml_mt:enja_dev_0000000002": " 使用可能な値を表示するには、<uicontrol>[値を検索...]</uicontrol> ボックスを空のままにして、<uicontrol>[検索]</uicontrol> をクリックします。",
        "salesforce_localization_xml_mt:enja_dev_0000000003": " プロファイルへのコンソールレイアウトの割り当て",
        "salesforce_localization_xml_mt:enja_dev_0000000004": " さまざまなアプリケーションおよびオブジェクトのカスタマイズ機能へのショートカットは Salesforce Classic でのみ使用できます。",
        "salesforce_localization_xml_mt:enja_dev_0000000005": " レポートフォルダを作成および共有する",
     ...
```

, where the file format is consistent with that of the training data, and here we also show an example file for "translation" based on our actual translation results reported in <a href="https://www.aclweb.org/anthology/W19-5212/">our paper</a>.
The development data can be used to estimate the quality of a model trained with the training data.
Section 2.3, 2.4, and 2.5 describe how to run our official evauation script to obtain several evaluation scores.
<br><br>
Finally, we show the test data:

```bash
{
    "lang": "en",
    "type": "source",
    "text": {
        "salesforce_localization_xml_mt:enja_test_0000000001": "equal",
        "salesforce_localization_xml_mt:enja_test_0000000002": "The predicate expression must have the following syntax:",
        "salesforce_localization_xml_mt:enja_test_0000000003": "To configure SSO for Salesforce to SpringCM, follow these high-level steps.",
        "salesforce_localization_xml_mt:enja_test_0000000004": "If your administrator applied a library tagging rule, you may not be able to enter new tags. If the guided tagging rule is applied, you can click <uicontrol>Add Tags</uicontrol> and choose from the list of suggested tags or enter new tags. If the restricted library tagging rule is applied, you can click <uicontrol>Add Tags</uicontrol> and choose from the list of suggested tags, but you cannot enter your own tags.",
        "salesforce_localization_xml_mt:enja_test_0000000005": "Picklist field values can be added or deleted in the developer’s organization. Upon upgrade, no new values are installed. Any values deleted by the developer are still available in the subscriber’s organization until the subscriber deletes them.",
     ...
```

, where the format is exactly the same as before, <b>except that we do not provide the "target" file</b>.
Section 2.6 describes how to obtain a final test result.

### 2.2 Notes on running experiments on this task
* <b>Escaped characters</b> <br>
In this dataset, the three special characters `&`, `<`, and `>` are represented with `&amp;`, `&lt;`, and `&gt;`, respectively.
This is applicable only to the content text; that is, XML/HTML tags are represented with `<` and `>` as usual.
Therefore, if `<` and `>` are used for non-tag text, XML parsing process would fail in the evaluation stage, which would result in low evaluation scores.

* <b>Preprocessing source (English) strings</b> <br>
Any preprocessing is acceptable in the source side language, English.

* <b>Preprocessing/postprocessing target strings</b> <br>
However, for the target side languages, we require any system to output strings that look like the original text; in other words, the output text needs to be immediately readable by humans.
This is because our goal is not just doing machine translation research, but is building a system immediately useful in localization industory.
For example, outputting lowercased strings is not relevant to this task.
<b>The evaluation is always performed in a case-sensitive manner.</b>
Another important note is that <b>we do not assume any further tokenization</b> in all the translated strings.
In that sense, one recommendation is using a reversible tokenizer like <a href="https://github.com/google/sentencepiece">SentencePiece</a>.
Our data are stored as UTF-8 text.

* <b>Combining multiple languages together</b> <br>
We do not support training with multiple languages in this dataset.
There can be overlap between the test data in one language and the training data in another language.
We will consider constructing a multilingually-aligned dataset in the future, but at this point each language pair needs to be separately handled in this dataset.

* <b>Using other training resources</b> <br>
You can use external training data to improve translation quality in this dataset.
At the time when you submit your test results, please mention that you used additional resources.
Please refer to Section 2.6 for details about how to mention that.

### 2.3 Basic requirements to use the official evaluation script
* Python 3.X <br>
* <a href="https://lxml.de/">lxml</a> for parsing output XML strings
```bash
$ pip install lxml
```
* <a href="https://github.com/moses-smt/mosesdecoder">mosesdecoder</a> for tokenization and BLEU
```bash
$ ./install_moses.sh
```

### 2.4 Evaluating Japanese (ja) or Simplified Chinese (zh) results
To evaluate Japanese and Simplified Chinese translation results, we follow the BLEU evaluation of the <a href="http://lotus.kuee.kyoto-u.ac.jp/WAT/">Workshop on Asian Translation (WAT)</a>.
The <a href="http://www.phontron.com/kytea/">KyTea</a> toolkit is used for the postprocessing step before computing BLEU scores.
To install KyTea and download scripts necessary to use our official evaluation script, simply run
```bash
$ ./install_kytea_and_wat_scripts.sh
```
here.
Then you can use the official evaluation script by running a command like this:
```bash
$ python ./scripts/evaluate.py --translation ./examples/enja_translation.json --target ./data/enja/enja_ja_dev.json --english_term ./scripts/english_terms.json
```
or
```bash
$ python ./scripts/evaluate.py --translation ./examples/enzh_translation.json --target ./data/enzh/enzh_zh_dev.json --english_term ./scripts/english_terms.json
```
We assume that `python ./scripts/evaluate.py` is run in this directory (or just here in this repository).

### 2.5 Evaluating Dutch (nl), Finnish (fi), French (fr), German (de), or Russian (ru) results
For the other languages, we use the <a href="https://github.com/moses-smt/mosesdecoder">mosesdecoder</a> tokenizer before computing BLEU scores.
You can use the official evaluation script, for example for French, by running a command like this:
```bash
$ python ./scripts/evaluate.py --translation ./examples/enfr_translation.json --target ./data/enfr/enfr_fr_dev.json --english_term ./scripts/english_terms.json
```
We assume that `python ./scripts/evaluate.py` is run in this directory (or just here in this repository).

### 2.6 Submitting test set results
When you are confident enough to conduct final evaluation on the test data, you can send an email like this:

```bash
[To]
k.hashimoto<AT>salesforce.com (please replace <AT> with @)

[Subject]
Test Evaluation for XML Translation

[Body]
ID: n/a
System name: a system name or anonymous
Paper: n/a
Additional training data: Yes or No

[Attachment]
a zip file containing files like "enXX_XX_test.json" for languages XX you want to evaluate.
```

, and later if you want to update the information, you can send another email like this:

```bash
[To]
k.hashimoto<AT>salesforce.com (please replace <AT> with @)

[Subject]
Updates for XML Translation

[Body]
ID: the ID we send when we reply to the first submission
System name: a system name
Paper: a URL
```

Although the paper information is not a must, we would like you to report your methods in papers as much as possible.
To prepare for the submission, or in other words to output a "translation" file in the official format, you can use the following script:

```bash
$ python ./scripts/convert2json.py --help
usage: convert2json.py [-h] --input INPUT --output OUTPUT --lang LANG --type
                       TYPE [--split SPLIT]

optional arguments:
  -h, --help       show this help message and exit
  --input INPUT    File path to a text file to be read
  --output OUTPUT  File path to a JSON file to be output
  --lang LANG      Language code {ja, zh, nl, fi, fr, de, ru}
  --type TYPE      Translation text type {source, target, translation}
  --split SPLIT    Data split {train, dev, test}

$ python ./scripts/convert2json.py --input <a text file> --output <a json file path> --lang XX --type translation --split test
```

, assuming that the input file contains a translated string in each line in the order of the original ID.
Then the script automatically converts the input file to a json file.
We recommend that you try this process with the development data.


## 3. Leaderboard (Test Set Results)
The tables below show test set results for all the languages covered in this dataset.
The "Baseline" entry comes from <a href="https://www.aclweb.org/anthology/W19-5212/">our paper</a>, where the scores are reported in Table 2 and 4.
For more details about the evaluation metrics, please refer to the paper.

### German (ende)
| System | XML BLEU | BLEU | Structure Acc. | Structure Match | NE&NUM Precision |  NE&NUM Recall |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: |
| <a href="https://www.aclweb.org/anthology/W19-5212/">Baseline</a> | 50.47 | 52.69 | 99.80 | 99.20 | 88.22 | 88.45 |

### Finnish (enfi)
| System | XML BLEU | BLEU | Structure Acc. | Structure Match | NE&NUM Precision |  NE&NUM Recall |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: |
| <a href="https://www.aclweb.org/anthology/W19-5212/">Baseline</a> | 44.22 | 45.71 | 99.90 | 99.65 | 87.38 | 88.91 |

### French (enfr)
| System | XML BLEU | BLEU | Structure Acc. | Structure Match | NE&NUM Precision |  NE&NUM Recall |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: |
| <a href="https://www.aclweb.org/anthology/W19-5212/">Baseline</a> | 63.19 | 65.04 | 99.80 | 99.35 | 88.98 | 88.31 |

### Japanese (enja)
| System | XML BLEU | BLEU | Structure Acc. | Structure Match | NE&NUM Precision |  NE&NUM Recall |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: |
| <a href="https://www.aclweb.org/anthology/W19-5212/">Baseline</a> | 62.27 | 64.34 | 99.95 | 99.60 | 93.39 | 91.75 |

### Dutch (ennl)
| System | XML BLEU | BLEU | Structure Acc. | Structure Match | NE&NUM Precision |  NE&NUM Recall |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: |
| <a href="https://www.aclweb.org/anthology/W19-5212/">Baseline</a> | 60.19 | 61.01 | 99.90 | 99.85 | 87.66 | 90.84 |

### Russian (enru)
| System | XML BLEU | BLEU | Structure Acc. | Structure Match | NE&NUM Precision |  NE&NUM Recall |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: |
| <a href="https://www.aclweb.org/anthology/W19-5212/">Baseline</a> | 44.25 | 46.44 | 99.80 | 99.35 | 86.90 | 89.59 |

### Simplified Chinese (enzh)
| System | XML BLEU | BLEU | Structure Acc. | Structure Match | NE&NUM Precision |  NE&NUM Recall |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: |
| <a href="https://www.aclweb.org/anthology/W19-5212/">Baseline</a> | 57.92 | 59.86 | 99.75 | 99.40 | 93.49 | 93.11 |


## 4. Paper
* ACL anthology: https://www.aclweb.org/anthology/W19-5212/ <br>
(Citation: https://www.aclweb.org/anthology/W19-5212.bib) <br>

## 5. Notes
* This dataset was created from a particular release of the Salesforce online help, and the development and test sets also follow the same resource.
However, in reality, we need to localize <b>new contents (or pages)</b>, so in the future we will consider creating another set of evaluation examples based on <b>a more recent release</b>.

## 6. Questions?
Feel free to open an issue or send an email to Kazuma Hashimoto: `k.hashimoto<AT>salesforce.com` (please replace `<AT>` with @)
