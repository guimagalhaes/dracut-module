# Using Dracut do customize an initramfs image

Check these scripts and comments below as a tutorial about how to add Dracut modules or how to add configuration steps, binaries and hook scripts to initramfs images.

The dracut command is used to customize a initramfs image for the current installed/running kernel or any other available version. It allows to inject hook scripts, '/dev/' entries, kernel drivers, kernel parameters and much more. See the dracut command manual for more. 

For adding a new hook script to a initramfs image, it is required to add a new Dracut module. The initramfs supports some hooks, which depend on specific kernel boot stage, see the update_initramfs.sh script for how to do it. The update_initramfs.sh script creates a new folder at /usr/lib/dracut/modules.d with the modules_setup.sh mandatory file and any other file which should be added to the initramfs image. The modules_setup.sh script must implement check(), depends() and install(). 

- The check() function must return 0 if the module is always added to the initramfs image, otherwise, the dracut command must be used with '--add <module>'.
- The install() function can used built-in functions to add hook scripts, configuration files and binaries to the initramfs image.

Initramfs hook scripts are sourced by the initramfs init scripts and then it should be avoided calls to 'exit' from hook scripts.

More details about the `dracut´ command parameters at https://www.systutorials.com/docs/linux/man/8-dracut/.

To add a new script hook to the initramfs image, in the install() function of the module_setup.sh script, use:

`inst_hook <hook> <priority> "$moddir/script.sh"`
  
The 'hook' value is one of the available initramfs hook folders. The `$moddir` points to the Dracut module absolute path and 'script.sh' is the new hook script to be injected to the initramfs image. The 'priority' number is used to order the hook scripts if some script in the that hook folder is required to be executed first.

More details about Dracut modules, its built-in functions and initramfs hooks at http://man7.org/linux/man-pages/man7/dracut.modules.7.html.

To debug initramfs image during a system boot, use these kernel parameters to enter into a shell during the initramfs init execution:

`rd.shell rd.debug rd.break=[hook]`

To list existing initramfs hooks:

`egrep 'rd.?break' /usr/lib/dracut/modules.d/99base/init.sh`

More details about debugging initramfs at https://fedoraproject.org/wiki/How_to_debug_Dracut_problems#Debugging_dracut.
