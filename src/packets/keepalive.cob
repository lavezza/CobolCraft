IDENTIFICATION DIVISION.
PROGRAM-ID. SendPacket-KeepAlive.

DATA DIVISION.
WORKING-STORAGE SECTION.
    01 PACKET-ID    BINARY-LONG             VALUE H'27'.
    *> buffer used to store the packet data
    01 PAYLOAD      PIC X(8).
    01 PAYLOADPOS   BINARY-LONG UNSIGNED.
    01 PAYLOADLEN   BINARY-LONG UNSIGNED.
LINKAGE SECTION.
    01 LK-CLIENT        BINARY-LONG UNSIGNED.
    01 LK-KEEPALIVE-ID  BINARY-LONG-LONG.

PROCEDURE DIVISION USING LK-CLIENT LK-KEEPALIVE-ID.
    MOVE 1 TO PAYLOADPOS
    CALL "Encode-Long" USING LK-KEEPALIVE-ID PAYLOAD PAYLOADPOS
    COMPUTE PAYLOADLEN = PAYLOADPOS - 1
    CALL "SendPacket" USING LK-CLIENT PACKET-ID PAYLOAD PAYLOADLEN
    GOBACK.

END PROGRAM SendPacket-KeepAlive.
