# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
#   Copyright (c) 2014 Red Hat, Inc. All rights reserved.
#
#   Author: CAI Qian    <caiqian@redhat.com>
#   Update: Guangze Bai <gbai@redhat.com>
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

export TEST        := /kernel/kdump/lib
export TESTVERSION := 3.0

include /usr/share/rhts/lib/rhts-make.include

.PHONY: build run clean


FILES := Makefile common.sh crash.sh env.sh kdump.sh log.sh 

build:
	echo "It can not build."; exit 1;

run: $(FILES) build
	echo "This is a library, can not run!"; exit 1;

$(METADATA): Makefile
	touch $(METADATA)
	@echo "Name:          $(TEST)"                           > $(METADATA)
	@echo "TestVersion:   $(TESTVERSION)"	                >> $(METADATA)
	@echo "Path:          $(TEST_DIR)"                      >> $(METADATA)
	@echo "TestTime:      1h"                               >> $(METADATA)
	@echo "License:       GPLv3"                            >> $(METADATA)
	@echo "Owner:         CAI Qian <caiqian@redhat.com>"    >> $(METADATA)
	@echo "RhtsRequires:  kernel-kernel-kdump-lib"      >> $(METADATA)
	@echo "Architectures: i386 x86_64 ia64 ppc ppc64 s390x" >> $(METADATA)
	@echo "Description:   Basic Library for Kdump testing."     >> $(METADATA)




