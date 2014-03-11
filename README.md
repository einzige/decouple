# Decouple FTW!
[![Gem Version](https://badge.fury.io/rb/decouple.png)](http://badge.fury.io/rb/decouple)
[![Build Status](http://travis-ci.org/einzige/decouple.png?branch=master)](https://travis-ci.org/einzige/decouple)

Decouples long ruby methods (sounds strange, right?) in a pretty weird unnatural way. Please use _PRIVATE_ methods instead, extract classes, objects, do whatever is possible not to use it. That's a really bad idea, NEVER use it. I DO ALWAYS USE NATURAL LANGUAGE CONSTRUCTIONS.

Exactly the same thing you can do using Observers, metaprogramming etc... Please also reffer to Module#prepend.

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
    # Another thousand lines code
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

It is preferred not to populate hard logic in `decouple` block, better create multiple `decouple` blocks if possible.

### Testing

Never decouple tests (it is like testing private methods). All you do in your decoupled blocks - it is still the same method you decouple.

```ruby
subject { MyClass.new }

# Put all your tests here, don't decouple tests!
describe '#send_email' do
  it 'delivers emails to grandma' do
    expect { subject.send_email(:to_grandma) }.to deliver_emails
  end
end
```

Anyways... :)

```ruby
subject { MyClass.new }

describe 'callbacks' do
  # <paranoid_mode>
  specify do
    expect(:subject).to receive(:proceed_action).with(:something)
    subject.send_email
  end
  # </paranoid_mode>

  describe 'on #send_email' do
    it 'delivers emails to grandma' do
      expect { subject.proceed_with(:send_email, :to_grandma) }.to deliver_emails
    end
  end
end
```
