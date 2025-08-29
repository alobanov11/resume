.PHONY: all pdf install clean setup-hooks

all: pdf

install:
	brew install pandoc
	brew install --cask basictex
	eval "$(/usr/libexec/path_helper)"
	sudo tlmgr update --self
	sudo tlmgr install collection-fontsrecommended
	sudo tlmgr install collection-fontsextra
	sudo tlmgr install cyrillic cm-super

pdf: clean en.pdf ru.pdf

en.pdf: Readme.md
	pandoc Readme.md -o en.pdf --pdf-engine=xelatex -V geometry:margin=1in -V mainfont="PT Serif" --pdf-engine-opt=-shell-escape

ru.pdf: ru.md
	pandoc ru.md -o ru.pdf --pdf-engine=xelatex -V geometry:margin=1in -V lang=ru -V mainfont="PT Serif" --pdf-engine-opt=-shell-escape

clean:
	rm -f en.pdf ru.pdf

setup-hooks: install
	cp -f .git/hooks/pre-commit .git/hooks/pre-commit.backup 2>/dev/null || true
	cp -f pre-commit .git/hooks/
	chmod +x .git/hooks/pre-commit
	@echo "Git pre-commit hook установлен. PDF файлы будут автоматически генерироваться перед коммитом."
