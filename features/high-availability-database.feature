Feature: Redundant database setup
     In order to ensure we store our users data is safe
     As an OpenSaaS developer
     I setup my database redundantly to have 3 copies of the data

Background: database cluster is running
     Given a database cluster is up and running
     And a set of demo data is loaded

Scenario: demo data is stored 3 times
     Given 500 demo records loaded
     When these 500 demo records are written to the database
     Then no errors should occur
     And the 500 records should be stored in 3 copies

Scenario: Increase redundancy
     Given 500 demo records loaded
     When a new node is added to the cluster
     Then that node should contain all demo data

Scenario: 1 node down shouldn't give read/write errors
     Given 500 demo records loaded
     And read and write load is applied to the cluster
     When 1 node of the cluster is stopped
     Then the client should see no read or write errors

Scenario: 1 node down should trigger logging event
     Given 500 demo records loaded
     When 1 node of the cluster is stopped
     Then the monitoring system should receive a node down event
