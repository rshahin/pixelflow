Download and install Git.

Create a .bashrc file in your user directory.*

* You can go into user directory, open git bash and then type `touch .bashrc` 



Add the following to the file and save.

`
alias wpinstall="curl -L -o 'flow.sh' https://raw.githubusercontent.com/rshahin/pixelflow/master/flow.sh && bash flow.sh"
`

Once all that's done. Go into your dev/theme folder. Open Git bash shell. Run `wpinstall`.