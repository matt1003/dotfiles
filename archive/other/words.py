
from random import randrange

common_words = """
the be to of and a in that have I
it for not on with he as you do at
this but his by from they we say her she
or an will my one all would there their what
so up out if about who get which go me
when make can like time no just him know take
people into year your good some could them see other
than then now look only come its over think also
back after use two how our work first well way
even new want because any these give day most us
""".split()

spelling_words = """
absolutely
aggressively
answer
architecture
asynchronous
auto-negotiation
available
calendar
coming
declare
diagnostic
disregard
eliminate
especially
guarantee
instantiate
opinion
priority
reliability
responsible
specifically
stretch
surprised
""".split()

names = """
Slovenia
""".split()

commands = """
unhide helpdesk-group
helpdesk shell
GigabitEthernet1/0/1
TenGigE1/0/1
sfp_util
port_diag
""".splitlines()

word_list = list(filter(None, common_words + spelling_words + names + commands))

while word_list:
    word = word_list[randrange(len(word_list))]
    word_list.remove(word)
    print(word + " ", end="")
