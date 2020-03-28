.. _acrn-board-parser:

Standalone ACRN Board Parser
############################

`ACRN configuration tool`_ is developed to customize `ACRN`_ for a varity of hardware
platforms. Part of the following ACRN offline tool workflow requires running the tool on
a target board to get the hardware resource info of the board.

Files in this repo instruct the `Clear Linux Installer`_ to create a bootable live image,
which can be flashed to a USB key, then boot the USB key on the target platform to get
the board info. The board info is captured and stored on the USB key during the bootstrap,
you can then transfer the data in the USB key to your development system, and use
the web app of ACRN offline configuration tool to import the data and continue
the scenario and VM configuration customizations.

.. figure:: https://projectacrn.github.io/latest/_images/offline_tools_workflow.png
    :alt: ACRN offline tool workflow
    :align: center

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
   :file:`/opt/workspace/acrn-hypervisor/misc/acrn-config/target/out/target.xml`.

   You don't even need to log in Clear Linux OS on the target device.

#. Plug the USB key to your development workstation, mount the 4th partition
   of the USB key, and copy the captured board info :file:`target.xml` for being
   imported by the web app of ACRN offline configuration tool.

    .. code-block:: console

        $ sudo mount /dev/sdb4 /mnt
        $ cp /mnt/acrn-hypervisor/misc/acrn-config/target/out/target.xml ~

.. _ACRN: https://projectacrn.github.io/latest/index.html
.. _ACRN configuration tool: https://projectacrn.github.io/latest/tutorials/acrn_configuration_tool.html
.. _Clear Linux OS: https://clearlinux.org/
.. _Clear Linux Installer: https://github.com/clearlinux/clr-installer
