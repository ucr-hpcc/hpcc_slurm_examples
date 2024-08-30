---
linkTitle: "VSCode"
title: "VSCode Usage on HPCC"
type: docs
weight: 1
---

## Using VSCode on the Cluster

VSCode is a code editor that can run locally on your computer, or while connected to the cluster.

When using VSCode on the cluster, please do not use Remote SSH as it will launch the code server on a head node, causing unneeded load.

Instead, we can use a feature of VSCode: [Remote Tunnels](https://code.visualstudio.com/docs/remote/tunnels).

## Setting up VSCode Tunnels

Using a tunnel allows us to work on a compute node, rather than on a head node. This allows us to use more resources than we would normally be allowed to on a head node.

### Installing the Remote Tunnels extension

On your local machine, install the "Remote - Tunnels" extension.

![vscodeinstall](/img/vscode-ext-install.png)

### Starting VSCode Tunnel on the Cluster

Create an interactive session using srun

```sh
srun -p epyc -t 5:00:00 --pty -c 4 --mem=4g bash -l  # Customize as needed
```

Load the VSCode module and start the tunnel

```sh
module load vscode
code tunnel
```

The program will provide you with a code and ask you to verify on GitHub.com. Follow the steps for authorization.
Once you get to the "Congratulations, you're all set!" page, the terminal will update with a new line asking you to open another link.
At this point you have 2 ways to access: via a web browser, or using the extension that we previously installed. Make sure that you keep
the server running in the background, as it is what allows the connection to occur.

### Using A Web Browser

After authorizing VSCode, you can use the link given to access your session. The URL should be similar to `https://vscode.dev/tunnel/...`.
The environment is very similar to the desktop program, though some features might be missing.

### Using the VSCode Extension

After install the "Remote - Tunnels" extension on your local machine, connect to the Tunnel session that was previously created using the green "><"
icon in the bottom left of VSCode. Select the "Connect to Tunnel..." option, then select the tunnel we created earlier.

![vscodeinstall](/img/vscode-tunnel1.png)

![vscodeinstall](/img/vscode-tunnel2.png)

After VSCode connects, you should be able to open Files and Folders on the cluster as if it were your local machine.

### Using the Built-In Terminal

One feature that VSCode integrates is an in-editor terminal. To activate it, you can use the keyboard shortcut `` Ctrl+` ``, or via `View > Terminal` from the status bar.

By default, you might be dropped into a basic shell without some of the features that you are used to (eg. with the prompt `bash-4.4$` instead of `username@node`). To fix this, you can type `bash -l` that should bring you to the terminal environment that you are used to, and from here you can navigate and use the cluster as if it was any other terminal program.

### Cleaning Up

Once you have finished, make sure to close VSCode (locally or using your web browser). Then stop the Tunnel from running on the cluster using `Ctrl+C`.
Once the program had been stopped, you can exit out of the interactive srun session and close your terminal.
