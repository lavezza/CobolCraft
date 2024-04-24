IDENTIFICATION DIVISION.
PROGRAM-ID. SendPacket-FeatureFlags.

DATA DIVISION.
WORKING-STORAGE SECTION.
    01 PACKET-ID        BINARY-LONG             VALUE H'0C'.
    *> buffer used to store the packet data
    01 PAYLOAD          PIC X(1024).
    01 PAYLOADLEN       BINARY-LONG UNSIGNED.
    *> temporary
    01 INT32            BINARY-LONG.
    01 BUFFER           PIC X(8).
    01 BUFFERLEN        BINARY-LONG UNSIGNED.
LINKAGE SECTION.
    01 LK-HNDL          PIC X(4).
    01 LK-ERRNO         PIC 9(3).

PROCEDURE DIVISION USING LK-HNDL LK-ERRNO.
    MOVE 0 TO PAYLOADLEN

    *> count = 1
    MOVE 1 TO INT32
    CALL "Encode-VarInt" USING INT32 BUFFER BUFFERLEN
    MOVE BUFFER TO PAYLOAD(PAYLOADLEN + 1:BUFFERLEN)
    ADD BUFFERLEN TO PAYLOADLEN

    *> feature flag: "minecraft:vanilla"
    MOVE FUNCTION CHAR(17 + 1) TO PAYLOAD(PAYLOADLEN + 1:1)
    ADD 1 TO PAYLOADLEN
    MOVE "minecraft:vanilla" TO PAYLOAD(PAYLOADLEN + 1:17)
    ADD 17 TO PAYLOADLEN

    *> send packet
    CALL "SendPacket" USING LK-HNDL PACKET-ID PAYLOAD PAYLOADLEN LK-ERRNO
    GOBACK.

END PROGRAM SendPacket-FeatureFlags.
