# catch " hostname "
s/\s[[:alpha:]]+\s/|/

# catch " [#] "
s/\[[[:digit:]]+\]:\s/|/

# catch " from "
#s/\sfrom\s/|/

# catch " port "
#s/\sport\s/|/
