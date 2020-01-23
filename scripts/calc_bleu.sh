#!/bin/sh

WAT_LOC=./tools/WAT-scripts/
KYTEA=./tools/local/bin/kytea
KYTEA_MODEL=./tools/kytea_models/

MOSES_TOK=./tools/mosesdecoder/scripts/tokenizer/tokenizer.perl

MULTI_BLEU=./tools/mosesdecoder/scripts/generic/multi-bleu.perl

L=${1}
LOC=${2}

T=trans.txt
G=gold.txt
T_S=trans_struct.txt
G_S=gold_struct.txt

if [ ${L} = "ja" ]; then
    cat ${LOC}/${T} | sed -r 's/(@@ )|(@@ ?$)//g' | perl -C -pe 'use utf8; s/(.)［[０-９．]+］$/${1}/;' |sh ${WAT_LOC}/remove-space.sh |perl -C ${WAT_LOC}/h2z-utf8-without-space.pl | ${KYTEA} -model ${KYTEA_MODEL}/jp-0.4.2-utf8-1.mod -out tok | perl -C -pe 's/^ +//; s/ +$//; s/ +/ /g;' |perl -C -pe 'use utf8; while(s/([０-９]) ([０-９])/$1$2/g){} s/([０-９]) (．) ([０-９])/$1$2$3/g; while(s/([Ａ-Ｚ]) ([Ａ-Ｚａ-ｚ])/$1$2/g){} while(s/([ａ-ｚ]) ([ａ-ｚ])/$1$2/g){}' > ${LOC}/${T}.eval

    cat ${LOC}/${G} | sed -r 's/(@@ )|(@@ ?$)//g' | perl -C -pe 'use utf8; s/(.)［[０-９．]+］$/${1}/;' |sh ${WAT_LOC}/remove-space.sh |perl -C ${WAT_LOC}/h2z-utf8-without-space.pl | ${KYTEA} -model ${KYTEA_MODEL}/jp-0.4.2-utf8-1.mod -out tok | perl -C -pe 's/^ +//; s/ +$//; s/ +/ /g;' |perl -C -pe 'use utf8; while(s/([０-９]) ([０-９])/$1$2/g){} s/([０-９]) (．) ([０-９])/$1$2$3/g; while(s/([Ａ-Ｚ]) ([Ａ-Ｚａ-ｚ])/$1$2/g){} while(s/([ａ-ｚ]) ([ａ-ｚ])/$1$2/g){}' > ${LOC}/${G}.eval

    cat ${LOC}/${T_S} | sed -r 's/(@@ )|(@@ ?$)//g' | perl -C -pe 'use utf8; s/(.)［[０-９．]+］$/${1}/;' |sh ${WAT_LOC}/remove-space.sh |perl -C ${WAT_LOC}/h2z-utf8-without-space.pl | ${KYTEA} -model ${KYTEA_MODEL}/jp-0.4.2-utf8-1.mod -out tok | perl -C -pe 's/^ +//; s/ +$//; s/ +/ /g;' |perl -C -pe 'use utf8; while(s/([０-９]) ([０-９])/$1$2/g){} s/([０-９]) (．) ([０-９])/$1$2$3/g; while(s/([Ａ-Ｚ]) ([Ａ-Ｚａ-ｚ])/$1$2/g){} while(s/([ａ-ｚ]) ([ａ-ｚ])/$1$2/g){}' > ${LOC}/${T_S}.eval

    cat ${LOC}/${G_S} | sed -r 's/(@@ )|(@@ ?$)//g' | perl -C -pe 'use utf8; s/(.)［[０-９．]+］$/${1}/;' |sh ${WAT_LOC}/remove-space.sh |perl -C ${WAT_LOC}/h2z-utf8-without-space.pl | ${KYTEA} -model ${KYTEA_MODEL}/jp-0.4.2-utf8-1.mod -out tok | perl -C -pe 's/^ +//; s/ +$//; s/ +/ /g;' |perl -C -pe 'use utf8; while(s/([０-９]) ([０-９])/$1$2/g){} s/([０-９]) (．) ([０-９])/$1$2$3/g; while(s/([Ａ-Ｚ]) ([Ａ-Ｚａ-ｚ])/$1$2/g){} while(s/([ａ-ｚ]) ([ａ-ｚ])/$1$2/g){}' > ${LOC}/${G_S}.eval

elif [ ${L} = "zh" ]; then
    cat ${LOC}/${T} | sh ${WAT_LOC}/remove-space.sh | perl -C ${WAT_LOC}/h2z-utf8-without-space.pl | ${KYTEA} -model ${KYTEA_MODEL}/msr-0.4.0-1.mod -out tok | perl -C -pe 's/^ +//; s/ +$//; s/ +/ /g;' > ${LOC}/${T}.eval

    cat ${LOC}/${G} | sh ${WAT_LOC}/remove-space.sh | perl -C ${WAT_LOC}/h2z-utf8-without-space.pl | ${KYTEA} -model ${KYTEA_MODEL}/msr-0.4.0-1.mod -out tok | perl -C -pe 's/^ +//; s/ +$//; s/ +/ /g;' > ${LOC}/${G}.eval

    cat ${LOC}/${T_S} | sh ${WAT_LOC}/remove-space.sh | perl -C ${WAT_LOC}/h2z-utf8-without-space.pl | ${KYTEA} -model ${KYTEA_MODEL}/msr-0.4.0-1.mod -out tok | perl -C -pe 's/^ +//; s/ +$//; s/ +/ /g;' > ${LOC}/${T_S}.eval

    cat ${LOC}/${G_S} | sh ${WAT_LOC}/remove-space.sh | perl -C ${WAT_LOC}/h2z-utf8-without-space.pl | ${KYTEA} -model ${KYTEA_MODEL}/msr-0.4.0-1.mod -out tok | perl -C -pe 's/^ +//; s/ +$//; s/ +/ /g;' > ${LOC}/${G_S}.eval

else
    perl ${MOSES_TOK} -l ${L} < ${LOC}/${T} > ${LOC}/${T}.eval
    perl ${MOSES_TOK} -l ${L} < ${LOC}/${G} > ${LOC}/${G}.eval

    perl ${MOSES_TOK} -l ${L} < ${LOC}/${T_S} > ${LOC}/${T_S}.eval
    perl ${MOSES_TOK} -l ${L} < ${LOC}/${G_S} > ${LOC}/${G_S}.eval
fi

perl ${MULTI_BLEU} ${LOC}/${G}.eval < ${LOC}/${T}.eval > ${LOC}/bleu.txt
perl ${MULTI_BLEU} ${LOC}/${G_S}.eval < ${LOC}/${T_S}.eval > ${LOC}/bleu_struct.txt
