@sudo @open_flow13
Feature: Learning Switch example (OpenFlow1.3).
  Background:
    Given I use OpenFlow 1.3
    And a file named "trema.conf" with:
      """
      vswitch('learning') { datapath_id 0xabc }

      vhost('host1') { ip '192.168.0.1' }
      vhost('host2') { ip '192.168.0.2' }

      link 'learning', 'host1'
      link 'learning', 'host2'
      """

  Scenario: Run
    Given I trema run "lib/learning_switch13.rb" interactively with the configuration "trema.conf"
    And I run `sleep 8`
    When I run `trema send_packets --source host1 --dest host2`
    And I run `trema send_packets --source host2 --dest host1 --npackets 2`
    Then the number of packets received by "host1" should be:
      |      source | #packets |
      | 192.168.0.2 |        2 |
    And the number of packets received by "host2" should be:
      |      source | #packets |
      | 192.168.0.1 |        1 |

  Scenario: Run as a daemon
    Given I trema run "lib/learning_switch13.rb" with the configuration "trema.conf"
    And I run `sleep 8`
    When I successfully run `trema send_packets --source host1 --dest host2`
    And I successfully run `trema send_packets --source host2 --dest host1 --npackets 2`
    Then the number of packets received by "host1" should be:
      |      source | #packets |
      | 192.168.0.2 |        2 |
    And the number of packets received by "host2" should be:
      |      source | #packets |
      | 192.168.0.1 |        1 |
