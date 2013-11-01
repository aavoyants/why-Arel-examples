Code for "Arel. Why do we need it?" talk.
---------

Contains some samples, used for talk preparation.

Slides: https://speakerdeck.com/denyago/arel-why-do-we-need-it

Events:
- Lviv RUG #5 https://www.facebook.com/events/538666196213292
- Ruby Meditation 3 http://rubymeditation3.eventbrite.com/

Prepare and run
==

Don't forget to run `bundle` for the first time.

- `speed_comparation.rb` insert 10k postcodes to DB in different ways
- `trace_to_sql_benchmark.rb` compare speed of different 'where' generations in ActiveRecord
- `trace_to_sql_ruby-prof.rb` trace calls of methods in different 'where' generation ways. Use qcachegrind to see pretty picture.
