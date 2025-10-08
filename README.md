[![CI](https://github.com/Bodacious/RubyLLM/actions/workflows/ci.yml/badge.svg)](https://github.com/Bodacious/RubyLLM/actions/workflows/ci.yml)

# Exploring statistical language models in Ruby

## Looking for RubyLLM?

- https://github.com/crmne/ruby_llm
- https://rubyllm.com/


## WIP

See [TODO.md](./TODO.md) for the plan I'm working to at the moment.

## How to use

1. Download the repo `git clone https://github.com/Bodacious/RubyLM/`
2. cd into the repo `cd RubyLLM`
3. Install the local bundle `bundle install`
4. Install Python dependencies `pip install -r requirements.txt`
5. Run a query:

```bash
ruby -I talk_slides -r 15-temperature_scaling.rb -e "puts LanguageModel.new.generate" "the cat should not" 10000 0.3
```
