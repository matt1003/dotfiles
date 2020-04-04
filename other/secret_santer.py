
from random import randrange

# list of people to be in the secret santer
secret_santer_list = [ 'person1', 'person2', 'person3', 'person4' ]

# dict of people that cannot be paired together
blacklist = { 'person1': 'person2', 'person3': 'person4' }
blacklist.update(dict(reversed(i) for i in blacklist.items()))

for santer in list(secret_santer_list):
    while 1:
        person = secret_santer_list[randrange(len(secret_santer_list))]
        if santer != person and (not blacklist.has_key(santer) or blacklist[santer] != person):
            secret_santer_list.remove(person)
            print('{} => {}'.format(santer, person))
            break
