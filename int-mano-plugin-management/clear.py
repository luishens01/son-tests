#!/usr/bin/python
import sys
import pmclient as pmc

# ENDPOINT = "http://sp.int3.sonata-nfv.eu:8001"
# ENDPOINT = "http://127.0.0.1:8001"


def main():
    """
    Ask plugin manager for a list of plugins and
    remove pending testplugins if they are found.
    """
    if len(sys.argv) < 2:
        print("PM endpoint needed as first argument.")
        exit(1)
    ENDPOINT = sys.argv[1]
    uuid_list = pmc.plugin_list(ENDPOINT)
    print(uuid_list)
    for uuid in uuid_list:
        info = pmc.plugin_info(uuid, ENDPOINT)
        print(info)
        if info.get("name") == "son-plugin.TestPlugin":
            # found an old test plugin record, remove it!
            print("REMOVE: %r" % uuid)
            pmc.plugin_remove(uuid, ENDPOINT)


if __name__ == '__main__':
    print("=" * 48)
    print("BEGIN clean.py")
    main()
    print("END clean.py")
    print("=" * 48)
