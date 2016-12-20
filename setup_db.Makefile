# -*- indent-tabs-mode:t; -*-

# Make parameters
SHELL := bash
.SHELLFLAGS = -o pipefail -c
.PHONY: all download index

BASE_URL := https://urgi.versailles.inra.fr/download/iwgsc/Survey_sequence/
TARGET_DIR := ./global/blast_db/

IWGSC_FILES := 1AL_v2-ab-k71-contigs.fa.longerthan_200.fa.gz \
               1AS-ab-k71-contigs.fa.longerthan_200.fa.gz \
               1BL-ab-k71-contigs.fa.longerthan_200.fa.gz \
               1BS-ab-k71-contigs.fa.longerthan_200.fa.gz \
               1DL-ab-k95-contigs.fa.longerthan_200.fa.gz \
               1DS-ab-k71-contigs.fa.longerthan_200.fa.gz \
               2AL-ab-k71-contigs.fa.longerthan_200.fa.gz \
               2AS-ab-k71-contigs.fa.longerthan_200.fa.gz \
               2BL-ab-k71-contigs.fa.longerthan_200.fa.gz \
               2BS-ab-k71-contigs.fa.longerthan_200.fa.gz \
               2DL-ab-k71-contigs.fa.longerthan_200.fa.gz \
               2DS-ab-k71-contigs.fa.longerthan_200.fa.gz \
               3AL-ab-k71-contigs.fa.longerthan_200.fa.gz \
               3AS-ab-k71-contigs.fa.longerthan_200.fa.gz \
               3B-ab-k71-contigs.fa.longerthan_200.fa.gz \
               3DL-ab-k71-contigs.fa.longerthan_200.fa.gz \
               3DS-ab-k95-contigs.fa.longerthan_200.fa.gz \
               4AL_v2-ab-k71-contigs.fa.longerthan_200.fa.gz \
               4AS_v2-ab-k71-contigs.fa.longerthan_200.fa.gz \
               4BL-ab-k71-contigs.fa.longerthan_200.fa.gz \
               4BS-ab-k71-contigs.fa.longerthan_200.fa.gz \
               4DL_v3-ab-k71-contigs.fa.longerthan_200.fa.gz \
               4DS-ab-k71-contigs.fa.longerthan_200.fa.gz \
               5AL-ab-k95-contigs.fa.longerthan_200.fa.gz \
               5AS-ab-k95-contigs.fa.longerthan_200.fa.gz \
               5BL-ab-k71-contigs.fa.longerthan_200.fa.gz \
               5BS-ab-k71-contigs.fa.longerthan_200.fa.gz \
               5DL-ab-k71-contigs.fa.longerthan_200.fa.gz \
               5DS-ab-k71-contigs.fa.longerthan_200.fa.gz \
               6AL-ab-k71-contigs.fa.longerthan_200.fa.gz \
               6AS-ab-k71-contigs.fa.longerthan_200.fa.gz \
               6BL-ab-k71-contigs.fa.longerthan_200.fa.gz \
               6BS-ab-k71-contigs.fa.longerthan_200.fa.gz \
               6DL-ab-k71-contigs.fa.longerthan_200.fa.gz \
               6DS-ab-k71-contigs.fa.longerthan_200.fa.gz \
               7AL-ab-k71-contigs.fa.longerthan_200.fa.gz \
               7AS-ab-k71-contigs.fa.longerthan_200.fa.gz \
               7BL-ab-k71-contigs.fa.longerthan_200.fa.gz \
               7BS-ab-k71-contigs.fa.longerthan_200.fa.gz \
               7DL-ab-k71-contigs.fa.longerthan_200.fa.gz

BLAST_EXT := .nhr .nin .nog .nsd .nsi .nsq

BLAST_DB_FILES := $(foreach file,$(IWGSC_FILES),$(addprefix $(TARGET_DIR)$(file),$(BLAST_EXT)))

all: index

download: $(addprefix $(TARGET_DIR),$(IWGSC_FILES))
index: $(foreach file,$(IWGSC_FILES),$(addprefix $(TARGET_DIR)$(file),$(BLAST_EXT))) $(TARGET_DIR)IWGSC_SS.nal

$(TARGET_DIR)IWGSC_SS.nal: $(foreach file,$(IWGSC_FILES),$(addprefix $(TARGET_DIR)$(file),$(BLAST_EXT)))
	blastdb_aliastool -dblist "$(sort $(basename $^))" -dbtype nucl -out "$(basename $@)" -title "IWGSC Chromosomal Survey Sequences"

%.gz.nhr %.gz.nin %.gz.nog %.gz.nsd %.gz.nsi %.gz.nsq : %.gz
	gunzip -c $< | makeblastdb -in - -dbtype nucl -title "$(notdir $<)" -parse_seqids -out "$<"

%.gz :
	file="$(notdir $@)" && chr_arm="$${file//[-_]*}" && curl "$(BASE_URL)$(notdir $@)" | gunzip | sed "s/^>/>$${chr_arm}_/" | gzip --fast > "$@"

