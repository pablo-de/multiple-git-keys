# Setting up multiple GitLab accounts

Scenario: I needed to configure two ssh keys, one personal and one work, on the same machine. After following several guides, I decided to do it another way.

## Generate SSH keys
First generate two ssh keys.

`~/.ssh/id_rsa` and `~/.ssh/id_rsa.pub`

`/.ssh/work_rsa` and `~/.ssh/work_rsa.pub`

And configure them in Gitlab according to the [documentation](https://docs.gitlab.com/ee/user/ssh.html "documentation").

## Configure SSH to use the keys
Create the file `~/.ssh/config` and add the following contents:

    Host gitlab.com
        HostName gitlab.com
        User git
        IdentityFile ~/.ssh/id_rsa


I put all the work-related repositories inside the `~/work` directory, so I generated a little bash script in `~/.ssh/` called `git-with-ssh.sh`

```bash
#!/bin/bash

current_dir=$(pwd)

if [[ $current_dir == *"work"* ]]; then
  sed -i 's|IdentityFile ~/.ssh/id_rsa|IdentityFile ~/.ssh/work_rsa|' ~/.ssh/config
else
  sed -i 's|IdentityFile ~/.ssh/support-gitlab|IdentityFile ~/.ssh/id_rsa|' ~/.ssh/config
fi

git "$@"
```
When you're working inside that directory and use the `git` command, it uses the work key, instead if I'm in another directory, use my personal key.

Now we will generate an alias for the git command

In my case, when using zsh, what I did was generate an alias in `~/.zshrc`

`alias git='~/.ssh/git-with-ssh.sh'`

After adding the alias, remember to update your zsh configuration file with the command:

`source ~/.zshrc`

Now when you use git it will use the corresponding key.
