#!/bin/bash

function createOrg1() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/SFX.autocon.net/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/SFX.autocon.net/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca-org1 --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-org1.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-org1.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-org1.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-org1.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/SFX.autocon.net/msp/config.yaml

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-org1 --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-org1 --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-org1 --id.name org1admin --id.secret org1adminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/SFX.autocon.net/peers/peer0.SFX.autocon.net/msp --csr.hosts peer0.SFX.autocon.net --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/SFX.autocon.net/msp/config.yaml ${PWD}/organizations/peerOrganizations/SFX.autocon.net/peers/peer0.SFX.autocon.net/msp/config.yaml

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/SFX.autocon.net/peers/peer0.SFX.autocon.net/tls --enrollment.profile tls --csr.hosts peer0.SFX.autocon.net --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/SFX.autocon.net/peers/peer0.SFX.autocon.net/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/SFX.autocon.net/peers/peer0.SFX.autocon.net/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/SFX.autocon.net/peers/peer0.SFX.autocon.net/tls/signcerts/* ${PWD}/organizations/peerOrganizations/SFX.autocon.net/peers/peer0.SFX.autocon.net/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/SFX.autocon.net/peers/peer0.SFX.autocon.net/tls/keystore/* ${PWD}/organizations/peerOrganizations/SFX.autocon.net/peers/peer0.SFX.autocon.net/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/SFX.autocon.net/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/SFX.autocon.net/peers/peer0.SFX.autocon.net/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/SFX.autocon.net/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/SFX.autocon.net/tlsca
  cp ${PWD}/organizations/peerOrganizations/SFX.autocon.net/peers/peer0.SFX.autocon.net/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/SFX.autocon.net/tlsca/tlsca.SFX.autocon.net-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/SFX.autocon.net/ca
  cp ${PWD}/organizations/peerOrganizations/SFX.autocon.net/peers/peer0.SFX.autocon.net/msp/cacerts/* ${PWD}/organizations/peerOrganizations/SFX.autocon.net/ca/ca.SFX.autocon.net-cert.pem

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/SFX.autocon.net/users/User1@SFX.autocon.net/msp --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/SFX.autocon.net/msp/config.yaml ${PWD}/organizations/peerOrganizations/SFX.autocon.net/users/User1@SFX.autocon.net/msp/config.yaml

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://org1admin:org1adminpw@localhost:7054 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/SFX.autocon.net/users/Admin@SFX.autocon.net/msp --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/SFX.autocon.net/msp/config.yaml ${PWD}/organizations/peerOrganizations/SFX.autocon.net/users/Admin@SFX.autocon.net/msp/config.yaml
}

function createOrg2() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/JPL.autocon.net/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/JPL.autocon.net/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ca-org2 --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-org2.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-org2.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-org2.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-org2.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/JPL.autocon.net/msp/config.yaml

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-org2 --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-org2 --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-org2 --id.name org2admin --id.secret org2adminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-org2 -M ${PWD}/organizations/peerOrganizations/JPL.autocon.net/peers/peer0.JPL.autocon.net/msp --csr.hosts peer0.JPL.autocon.net --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/JPL.autocon.net/msp/config.yaml ${PWD}/organizations/peerOrganizations/JPL.autocon.net/peers/peer0.JPL.autocon.net/msp/config.yaml

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-org2 -M ${PWD}/organizations/peerOrganizations/JPL.autocon.net/peers/peer0.JPL.autocon.net/tls --enrollment.profile tls --csr.hosts peer0.JPL.autocon.net --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/JPL.autocon.net/peers/peer0.JPL.autocon.net/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/JPL.autocon.net/peers/peer0.JPL.autocon.net/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/JPL.autocon.net/peers/peer0.JPL.autocon.net/tls/signcerts/* ${PWD}/organizations/peerOrganizations/JPL.autocon.net/peers/peer0.JPL.autocon.net/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/JPL.autocon.net/peers/peer0.JPL.autocon.net/tls/keystore/* ${PWD}/organizations/peerOrganizations/JPL.autocon.net/peers/peer0.JPL.autocon.net/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/JPL.autocon.net/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/JPL.autocon.net/peers/peer0.JPL.autocon.net/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/JPL.autocon.net/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/JPL.autocon.net/tlsca
  cp ${PWD}/organizations/peerOrganizations/JPL.autocon.net/peers/peer0.JPL.autocon.net/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/JPL.autocon.net/tlsca/tlsca.JPL.autocon.net-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/JPL.autocon.net/ca
  cp ${PWD}/organizations/peerOrganizations/JPL.autocon.net/peers/peer0.JPL.autocon.net/msp/cacerts/* ${PWD}/organizations/peerOrganizations/JPL.autocon.net/ca/ca.JPL.autocon.net-cert.pem

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ca-org2 -M ${PWD}/organizations/peerOrganizations/JPL.autocon.net/users/User1@JPL.autocon.net/msp --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/JPL.autocon.net/msp/config.yaml ${PWD}/organizations/peerOrganizations/JPL.autocon.net/users/User1@JPL.autocon.net/msp/config.yaml

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://org2admin:org2adminpw@localhost:8054 --caname ca-org2 -M ${PWD}/organizations/peerOrganizations/JPL.autocon.net/users/Admin@JPL.autocon.net/msp --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/JPL.autocon.net/msp/config.yaml ${PWD}/organizations/peerOrganizations/JPL.autocon.net/users/Admin@JPL.autocon.net/msp/config.yaml
}

function createOrderer() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/ordererOrganizations/autocon.net

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/ordererOrganizations/autocon.net

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca-orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/ordererOrganizations/autocon.net/msp/config.yaml

  infoln "Registering orderer"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering the orderer admin"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Generating the orderer msp"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/autocon.net/orderers/orderer.autocon.net/msp --csr.hosts orderer.autocon.net --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/autocon.net/msp/config.yaml ${PWD}/organizations/ordererOrganizations/autocon.net/orderers/orderer.autocon.net/msp/config.yaml

  infoln "Generating the orderer-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/autocon.net/orderers/orderer.autocon.net/tls --enrollment.profile tls --csr.hosts orderer.autocon.net --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/autocon.net/orderers/orderer.autocon.net/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/autocon.net/orderers/orderer.autocon.net/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/autocon.net/orderers/orderer.autocon.net/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/autocon.net/orderers/orderer.autocon.net/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/autocon.net/orderers/orderer.autocon.net/tls/keystore/* ${PWD}/organizations/ordererOrganizations/autocon.net/orderers/orderer.autocon.net/tls/server.key

  mkdir -p ${PWD}/organizations/ordererOrganizations/autocon.net/orderers/orderer.autocon.net/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/autocon.net/orderers/orderer.autocon.net/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/autocon.net/orderers/orderer.autocon.net/msp/tlscacerts/tlsca.autocon.net-cert.pem

  mkdir -p ${PWD}/organizations/ordererOrganizations/autocon.net/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/autocon.net/orderers/orderer.autocon.net/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/autocon.net/msp/tlscacerts/tlsca.autocon.net-cert.pem

  infoln "Generating the admin msp"
  set -x
  fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/autocon.net/users/Admin@autocon.net/msp --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/autocon.net/msp/config.yaml ${PWD}/organizations/ordererOrganizations/autocon.net/users/Admin@autocon.net/msp/config.yaml
}


createOrderer
createOrg1
createOrg2