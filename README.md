# superblock
A shell script to determine when a DASH superblock occurs.

## Dependencies

You need to have the dash-cli in your PATH environment variable, update your ~/.profile to include its directory.  You also need the text calculator 'bc' installed this is because the shell cant handle floating point numbers on the commandline.  Get the package with ``sudo apt install bc``

## Running

    cd /tmp/
    git clone https://github.com/kxcd/superblock
    cd superblock
    chmod a+x supeblock.sh
    ./superblock


## Making it permanent

Once you are satisfied it runs well, add the function to your startup files so it runs automatically when you login and the ``superblock`` function is resident in the shell.

    head -n -2 superblock.sh |tail -n +3 >> ~/.bashrc
    echo -e "\nsuperblock\n" >> ~/.profile

Test that it works by ssh into the machine and by ``sudo su - <USER>``.  You should get a printed line informing you when the voting deadline is and when the superblock will be generated.
