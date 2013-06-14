.PHONY: default all byte opt test install reinstall uninstall clean

default:
	$(MAKE) -C elasticsearch

all:
	$(MAKE) -C elasticsearch all

byte:
	$(MAKE) -C elasticsearch byte

opt:
	$(MAKE) -C elasticsearch opt

test: opt
	$(MAKE) -C test test

install:
	$(MAKE) -C elasticsearch install

reinstall:
	$(MAKE) -C elasticsearch reinstall

uninstall:
	$(MAKE) -C elasticsearch uninstall

clean:
	$(MAKE) -C elasticsearch clean
	$(MAKE) -C test clean
