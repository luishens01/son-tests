import requests
import unittest
import yaml

NSR_REPOSITORY_URL = "http://10.31.11.36:4002/records/nsr/"
VNFR_REPOSITORY_URL = "http://10.31.11.36:4002/records/vnfr/"
MONITORING_REPOSITORY_URL= "http://10.31.11.36:8000/api/v1/services"

class checkRepositories(unittest.TestCase):

    # This test requests the NSR stored in the repoitory and checks that is contains the information sent by the SLM, built from
    # the sonata-demo service and functions descriptors.
    def testNsr(self):

        # [1] Get NSRs from repository
        r = requests.get(NSR_REPOSITORY_URL + "ns-instances")

        # [2] Check request ended successfully
        self.assertEqual(200, r.status_code, "Error requesting NSR to repository.")

        # [3] Extract NSR from response and check there only exists 1.
        nsrList = r.json()
        self.assertEqual(1, len(nsrList), "Repository should only contain 1 NSR")
        nsr = nsrList[0]

        # [4] Read from file the NSR that the SLM sent to Repository
        f = open("resources/test_records/expected-nsr.yml","r")
        expected_nsr = yaml.load(f)
        f.close()

        # [5] Check that the NSR stored in the repository contains the expected information
        self.assertEqual(nsr['uuid'], expected_nsr['id'], "Wrong id in NSR [" + nsr['uuid'] + "]")
        self.assertEqual(nsr['connection_points'], expected_nsr['connection_points'], "Wrong connection points information in NSR [" + nsr['uuid'] + "]")
        self.assertEqual(nsr['descriptor_reference'], expected_nsr['descriptor_reference'], "Wrong descriptor reference in NSR [" + nsr['uuid'] + "]")
        self.assertEqual(nsr['descriptor_version'], expected_nsr['descriptor_version'], "Wrong descriptor version in NSR [" + nsr['uuid'] + "]")
        self.assertEqual(nsr['forwarding_graphs'], expected_nsr['forwarding_graphs'], "Wrong forwarding_graphs information in NSR [" + nsr['uuid'] + "]")
        self.assertEqual(nsr['network_functions'], expected_nsr['network_functions'], "Wrong network_functions information in NSR [" + nsr['uuid'] + "]")
        self.assertEqual(nsr['status'], expected_nsr['status'], "Wrong status information in NSR [" + nsr['uuid'] + "]")
        self.assertEqual(nsr['version'], expected_nsr['version'], "Wrong version in NSR [" + nsr['uuid'] + "]")
        self.assertEqual(nsr['virtual_links'], expected_nsr['virtual_links'], "Wrong virtual_links information in NSR [" + nsr['uuid'] + "]")


    # This test requests the VNFRs stored in the repoitory and checks that is contains the information sent by the SLM, built from
    # the sonata-demo service and functions descriptors. The requested service consists of three network functions.
    def testVnfrs(self):

        def getRelatedVnfr(vnfrList, id):
            for vnfr in vnfrList:
                if vnfr['id'] == id:
                    return vnfr
            return None


        # [1] Get VNFRs from repository
        r = requests.get(VNFR_REPOSITORY_URL + "vnf-instances")

        # [2] Check request ended successfully
        self.assertEqual(200, r.status_code, "Error requesting VNFRs to repository.")

        # [3] Extract vNFRs from response and check that there are 3
        vnfrList = r.json()
        self.assertEqual(3, len(vnfrList), "Repository should contain 3 VNFRs.")

        # [4] Read from file the VNFRs that the SLM sent to Repository
        f = open("resources/test_records/expected-vnfrs.yml","r")
        expected_vnfrs = yaml.load(f)
        f.close()

        # [5] Check that the VNFRs stored in the repository contain the expected information
        for vnfr in vnfrList:

            related_vnfr = getRelatedVnfr(expected_vnfrs, vnfr['uuid'])
            self.assertIsNotNone(related_vnfr, "Unexpected vnfr with id [" + vnfr['uuid'] + "]")
            self.assertEqual(vnfr['connection_points'], related_vnfr['connection_points'], "Wrong connection_points information in VNFR [" + vnfr['uuid'] + "]")
            self.assertEqual(vnfr['descriptor_reference'], related_vnfr['descriptor_reference'], "Wrong descriptor_reference in VNFR [" + vnfr['uuid'] + "]")
            self.assertEqual(vnfr['descriptor_version'], related_vnfr['descriptor_version'], "Wrong descriptor_version in VNFR [" + vnfr['uuid'] + "]")
            self.assertEqual(vnfr['status'], related_vnfr['status'], "Wrong status in VNFR [" + vnfr['uuid'] + "]")
            self.assertEqual(vnfr['version'], related_vnfr['version'], "Wrong status in VNFR [" + vnfr['uuid'] + "]")
            self.assertEqual(vnfr['virtual_deployment_units'], related_vnfr['virtual_deployment_units'], "Wrong virtual_deployment_units information in VNFR [" + vnfr['uuid'] + "]")
            self.assertEqual(vnfr['virtual_links'], related_vnfr['virtual_links'], "Wrong virtual_links information in VNFR [" + vnfr['uuid'] + "]")



    def testMonitoring(self):

        # [1] Get services from monitoring manager
        r = requests.get(MONITORING_REPOSITORY_URL)

        # [2] Check request ended successfully
        self.assertEqual(200, r.status_code, "Error requesting services from monitoring manager.")

        # [3] Extract json from response
        response = r.json()

        # [4] Read NSR from file to compare with the information stored by the monitoring manager
        f = open("resources/test_records/expected-nsr.yml","r")
        nsr = yaml.load(f)
        f.close()

        # [5] Check that the monitoring manager is monitoring our service
        self.assertEqual(1, response['count'], "There should be only 1 monitored service.")
        self.assertEqual(1, len(response['results']), "There should be only 1 monitored service.")

        service = response['results'][0]

        self.assertEqual(nsr['id'], service['sonata_srv_id'])



if __name__ == "__main__":
    unittest.main()