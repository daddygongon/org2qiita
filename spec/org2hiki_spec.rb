require 'spec_helper'
require 'org2hiki'

def assert(org, hiki)
  converted = ToHiki.new.convert(org)
  expect(converted).to eq(hiki)
end

describe ToHiki do
  it "convert head lines" do
    assert('* head1', '! head1')
    assert('** head1', '!! head1')
    assert('*** head1', '!!! head1')
  end

  it "convert lists" do
    assert('- list1', '* list1')
    assert('  - list2', '** list2')
    assert('    - list3', '*** list3')
    assert('      - list4', '**** list4')
  end

  it "convert description" do
    assert('- list1 :: hoge', ': list1 : hoge')
  end

  it "convert attach view" do
    assert('[[file:./e.gif]]', '{{attach_view(e.gif)}}')
  end

  it "convert options to comments" do
    assert('#+hogehoge', '// #+hogehoge')
  end

  it "convert example" do
    org =<<-EOS
#+begin_example
example
#+end_example
EOS
    hiki =<<-EOS
<<<
example
>>>
EOS
    assert(org, hiki.chomp)
  end

  it "convert ruby src" do
    org =<<-EOS
#+begin_src ruby
ruby
#+end_src
EOS
    hiki =<<-EOS
<<< ruby
ruby
>>>
EOS
    assert(org, hiki.chomp)
  end
end
