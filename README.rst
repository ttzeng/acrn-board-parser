.. _acrn-board-parser:

Standalone ACRN Board Parser
############################

`ACRN configuration tool`_ is developed to customize `ACRN`_ for a varity of hardware
platforms. The following figure illustrates the workflow of the ACRN configuration tool,
which is started by installing a Linux distro on a target board, changing the booting kernel
command-line parameters, and installing a few Python dependencies once, to run the tool
and get the hardware resource info on the target board.

.. figure:: https://projectacrn.github.io/latest/_images/offline_tools_workflow.png
    :align: center

    ACRN offline tool workflow

To simplify the process, files in this repo instruct the `Clear Linux Installer`_ to create a bootable live image,
which can be flashed to a USB key, then boot the USB key on the target platform to get
the board info. The board info is captured and stored on the USB key during the bootstrap,
you can then transfer the data in the USB key to your development system, and use
the web app of ACRN offline configuration tool to import the data and continue
the scenario and VM configuration customizations.

Build Instructions
******************

#. Prerequisites

    - A device running `Clear Linux OS`_ release 30210 or later.
    - Install the latest :file:`clr-installer` bundle.

        .. code-block:: bash

            $ sudo swupd bundle-add clr-installer

#. Clone this repository and create a bootable live image:

    .. code-block:: bash

        $ git clone https://github.com/ttzeng/acrn-board-parser.git
        $ cd acrn-board-parser
        $ sudo clr-installer --config acrn-board-parser.yaml

#. Flash the generated bootable disk image :file:`acrn-board-parser.img` onto a USB key,
   and boot your target device from that USB key.

#. The ACRN board parser runs automatically during the system start up,
   it detects the hardware resources and writes the report to
   :file:`/opt/workspace/acrn-hypervisor/misc/acrn-config/target/out/<board_name>.xml`,
   where *<board_name>* is the name of the target board defined in the
   :abbr:`DMI (Desktop Management Interface)` firmware table.

   .. note::
      Though you don't need to log in the Clear Linux OS on target board,
      it's recommended to press the power button to shutdown the device,
      to ensure the board info is written back to the USB key.

   .. figure:: doc/screenshot-acrn-board-parser.jpg
       :align: center

       Screenshot of booting the ACRN Board Parser image

#. Plug the USB key to your development workstation, mount the 4th partition
   of the USB key, and copy the captured board info file *<board_name>.xml*
   to be imported by the web app of ACRN offline configuration tool.

    .. code-block:: console

        $ sudo mount /dev/sdb4 /mnt
        $ cp /mnt/acrn-hypervisor/misc/acrn-config/target/out/<board_name>.xml ~

   .. figure:: doc/import-by-config-app.png
       :align: center

       Import the board info to the ACRN configuration web app

.. _ACRN: https://projectacrn.github.io
.. _ACRN configuration tool: https://projectacrn.github.io/latest/tutorials/acrn_configuration_tool.html
.. _Clear Linux OS: https://clearlinux.org/
.. _Clear Linux Installer: https://github.com/clearlinux/clr-installer
