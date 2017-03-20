#!/usr/bin/python
import sys
import time
import pmclient as pmc

# ENDPOINT = "http://sp.int3.sonata-nfv.eu:8001"
# ENDPOINT = "http://127.0.0.1:8001"


def _get_test_plugin():
    ENDPOINT = sys.argv[1]
    uuid_list = pmc.plugin_list(ENDPOINT)
    print(uuid_list)
    # try to identify test plugin record
    for uuid in uuid_list:
        info = pmc.plugin_info(uuid, ENDPOINT)
        print(info)
        if info.get("name") == "son-plugin.TestPlugin":
            return info
    return None


def main():
    """
    Assumption: Testplugin was recently started.
    We now ask the PM about the running testplugin and validate
    that its registered correctly.
    After this, we try to remotely stop the plugin.
    """
    # give plugin some time to start
    time.sleep(3)

    if len(sys.argv) < 2:
        print("PM endpoint needed as first argument.")
        exit(1)
    ENDPOINT = sys.argv[1]
    # check if test plugin is not there
    test_info = _get_test_plugin()
    if test_info is None:
        raise BaseException("Test plugin record was not found!")

    # check test plugin record
    if test_info.get("state") != "RUNNING":
        raise BaseException("Test plugin state != RUNNING")

    # try to stop test plugin
    print("REMOVE: %r" % test_info.get("uuid"))
    pmc.plugin_remove(test_info.get("uuid"), ENDPOINT)

    # check if plugin is not there anymore
    time.sleep(3)
    test_info2 = _get_test_plugin()
    if test_info2 is not None:
        raise BaseException("Test plugin record was not removed correctly!")


if __name__ == '__main__':
    print("=" * 48)
    print("BEGIN test.py")
    main()
    print("END test.py")
    print("=" * 48)
