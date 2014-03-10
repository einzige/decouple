# Decouple FTW!
[![Gem Version](https://badge.fury.io/rb/decouple.png)](http://badge.fury.io/rb/decouple)
[![Build Status](https://travis-ci.org/einzige/decouple.png?branch=master)](https://travis-ci.org/einzige/decouple)
[![Dependency Status](https://gemnasium.com/einzige/decouple.png)](https://gemnasium.com/einzige/decouple)

Decouples long methods in a pretty weird unnatural way. Please use _PRIVATE_ methods instead, extract classes, objects, do whatever is possible not to use it. That's a really bad idea, NEVER use it. I DO ALWAYS USE NATURAL LANGUAGE CONSTRUCTIONS.

## Anyways... :)

```ruby
class MyClass
  include Decouple

  def send_email
    # 100 lines of code
    proceed_action
  end

  def send_letter
    # ...
    # Another thougsand lines code
    # ...
    proceed_action :to_grandma
  end

  private

  def burn_paper
    # bazillion lines of code
  end
end

# app/callbacks/safe_actions.rb
MyClass.decouple do
  on :send_email do
    Mailer.notify
  end

  on :send_letter do |receiver|
    Mailer.notify(receipient: receiver)
  end
end

# app/callbacks/burn_paper.rb
MyClass.decouple do
  on :send_email do
    burn_paper
  end
end
```

