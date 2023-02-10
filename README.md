# Setting up multiple GitLab accounts
Scenario: I needed to configure two ssh keys, one personal and one work, on the same machine. After following several guides, I decided to do it another way.

#### Generate Personal SSH Key
First generate the personal ssh key:
`~/.ssh/id_rsa` and `~/.ssh/id_rsa.pub`

#### Generate Work SSH Key
Next, generate the work ssh key:
`~/.ssh/work_rsa` and `~/.ssh/work_rsa.pub`

And configure them in GitLab according to the [documentation](https://docs.gitlab.com/ee/user/ssh.html "documentation").

#### Configure SSH to use the keys
Create the file `~/.ssh/config` and add the following contents:

    Host gitlab.com
        HostName gitlab.com
        User git
        IdentityFile ~/.ssh/id_rsa

I put all the work-related repositories inside the `~/work` directory, so I generated a little bash script in `~/.ssh/` called `git-with-ssh.sh`

    #!/bin/bash
	
    current_dir=$(pwd)
	
    if [[ $current_dir == *"work"* ]]; then
      sed -i 's|IdentityFile ~/.ssh/id_rsa|IdentityFile ~/.ssh/work_rsa|' ~/.ssh/config
    else
      sed -i 's|IdentityFile ~/.ssh/work_rsa|IdentityFile ~/.ssh/id_rsa|' ~/.ssh/config
    fi
	
    git "$@"
	

When you're working inside the `~/work` directory and use the git command, it uses the work key. If you're in another directory, it will use your personal key.

#### Generate alias for git command
Now, we will create an alias for the git command. In my case, when using zsh, I added the following alias in the `~/.zshrc` file:

`alias git='~/.ssh/git-with-ssh.sh'`

After adding the alias, remember to update your zsh configuration file with the following command:

`source ~/.zshrc`

Now when you use `git`, it will use the corresponding key.

#### Verify Correct Key is being Used
To verify that the correct key is being used, run the following command:
`git remote -v`

This will show the URL for the remote repository, and you can verify that it uses the correct SSH key.
