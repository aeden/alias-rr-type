# Introduction

## Background and Motivation

DNS [RFC 1035] forbids the use of CNAME records on a node with
other records. It is common practice for web sites publish
content on their second-level domain name, and currently the
only standards-compliant way to acheive this is to use A and
AAAA records on the zone apex.

The challenge with this limitation is that service providers
would like to have flexibility over their network addressing
but are required to communicate any address changes to all
customers and give appropriate time for customers to update their
DNS entries to ensure a smooth transition to a new address space.
As the number of customers increases for a service provider,
this approach becomes increasingly difficult to manage and
results in difficulties for both the service provider and their
customers.

The ALIAS record type (also known as ANAME or flattened CNAME)
provides a way for DNS managers to specify a hostname in their
DNS records which is then resolved to the correct A or AAAA
records at request time.

## Terminology

"QTYPE" - The query type as defined in [RFC1035] and subsequent
DNS RFCs.

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT",
"SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this
document are to be interpreted as described in RFC 2119 [RFC2119].

# The ALIAS Resource Record

Its RDATA is comprised of a single field, `target`, which contains a
fully qualified domain name that MUST be sent in uncompressed form
[RFC1035].  The `target` field MUST be present.  The presentation 
format of `target` is that of a domain name [RFC1035].

The presentation format of the RR is as follows:

```
    owner ttl class ALIAS target
```

An ALIAS record includes a TTL value that represents the maximum
time-to-live for a cached ALIAS record response in a resolver.

The ALIAS RDATA wire representation is only used for zone transfers.

# Implementation

## Resolution Guidelines

Authoritative name servers with support for ALIAS records MUST
support both A and AAAA materialization. When an authoritative name
server receives a request for a name, and the zone contains an
ALIAS record at that location, the authoritative name server MUST
respond as follows:

The server will respond with one or more A records (for a QTYPE A)
or one or more AAAA records (for a QTYPE AAAA) obtained by either:
* executing a recursive query for the ALIAS content or,
* returning a previously cached response.

If the recursive query returns an NXDOMAIN response, then the
authoritative name server MUST return an NXDOMAIN response as well.

If the recursive query fails, then the server MAY return a cached
response as long as the cache value is not older than the specified
TTL value.

## TTL Calculation

As described in section [3.1] the ALIAS is stored with its own TTL
value. When an ALIAS is resolved to its corresponding A or AAAA
records, the authoritative name server MUST return the TTL from
the resolver response.

When the authoritative name server uses a cached value, it returns
the lower TTL value.

## Handling CNAME QTYPE

Authoritative name servers that receive a CNAME request at a
an ALIAS node should treat the request as a QTYPE A.

Authoritative name servers that receive a CNAME request at an ALIAS
node MUST treat the request as a QTYPE A.

## Handling ANY QTYPE

Authoritative name servers that receive an ANY request at an ALIAS
node SHOULD respond with any A and AAAA records materialized from
the ALIAS record.

# Security Considerations

To function properly with DNSSEC-aware resolvers, authoritative
name servers MUST sign the materialized records produced by the
ALIAS resolution.

Implementors MAY either materialize A and AAAA records offline and
sign the resulting records at that time, or sign the resulting
materialized records at request time.

# Privacy Considerations

There are no additional privacy concerns introduced by this
document.

# IANA Considerations

This document uses a new DNS RR type, ALIAS, whose value must be
allocated by IANA from the Resource Record (RR) TYPEs subregistry of
the Domain Name System (DNS) Parameters registry.
