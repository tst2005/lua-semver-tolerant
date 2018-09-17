The current only blocking issue is about version formated 1.2.3.4
With semver 2.0.0. it seems not way to produce a valide semver greater than 1.2.3

the workaround is to inject the 4th field as float into PATCH

1.2.3.4 becomes
major 1
minor 2
patch 3.4

but it introduce a potential issue about vers ending by zero
1.2.3.1
1.2.3.10
1.2.3.100

or even compare
1.2.3.9
VS
1.2.3.10


for now
there is not issue for *.*.*.{from 0 to 9}


1.2.3.2 should be 1.2.3.02
if we have to compare with 1.2.3.10

1.2.3.2 should be 1.2.3.002
if we have to compare with 1.2.3.100

to a good comparison we need to store the 4th field "lenght"
