IDENTIFICATION DIVISION.
PROGRAM-ID. SendPacket-LoginPlay.

DATA DIVISION.
WORKING-STORAGE SECTION.
    01 PACKET-ID        BINARY-LONG             VALUE 41.
    *> temporary data used during encoding
    01 INT32            BINARY-LONG.
    01 BUFFER           PIC X(64).
    01 BUFFERLEN        BINARY-LONG UNSIGNED.
    *> buffer used to store the packet data
    01 PAYLOAD          PIC X(64000).
    01 PAYLOADLEN       BINARY-LONG UNSIGNED.
LINKAGE SECTION.
    01 LK-HNDL          PIC X(4).
    01 LK-ERRNO         PIC 9(3).

PROCEDURE DIVISION USING BY REFERENCE LK-HNDL LK-ERRNO.
    MOVE 0 TO PAYLOADLEN

    *> entity ID=0x00000001 (suffix of UUID)
    PERFORM 4 TIMES
        ADD 1 TO PAYLOADLEN
        MOVE FUNCTION CHAR(1) TO PAYLOAD(PAYLOADLEN:1)
    END-PERFORM
    MOVE FUNCTION CHAR(2) TO PAYLOAD(PAYLOADLEN:1)

    *> is hardcore=false
    ADD 1 TO PAYLOADLEN
    MOVE FUNCTION CHAR(1) TO PAYLOAD(PAYLOADLEN:1)

    *> dimension count=1
    MOVE 1 TO INT32
    CALL "Encode-VarInt" USING INT32 BUFFER BUFFERLEN
    MOVE BUFFER(1:BUFFERLEN) TO PAYLOAD(PAYLOADLEN + 1:BUFFERLEN)
    ADD BUFFERLEN TO PAYLOADLEN

    *> dimension name array=["minecraft:overworld"]
    ADD 1 TO PAYLOADLEN
    MOVE FUNCTION CHAR(19 + 1) TO PAYLOAD(PAYLOADLEN:1)
    MOVE "minecraft:overworld" TO PAYLOAD(PAYLOADLEN + 1:19)
    ADD 19 TO PAYLOADLEN

    *> max players=1
    MOVE 10 TO INT32
    CALL "Encode-VarInt" USING INT32 BUFFER BUFFERLEN
    MOVE BUFFER(1:BUFFERLEN) TO PAYLOAD(PAYLOADLEN + 1:BUFFERLEN)
    ADD BUFFERLEN TO PAYLOADLEN

    *> view distance=10
    MOVE 10 TO INT32
    CALL "Encode-VarInt" USING INT32 BUFFER BUFFERLEN
    MOVE BUFFER(1:BUFFERLEN) TO PAYLOAD(PAYLOADLEN + 1:BUFFERLEN)
    ADD BUFFERLEN TO PAYLOADLEN

    *> simulation distance=10
    MOVE 10 TO INT32
    CALL "Encode-VarInt" USING INT32 BUFFER BUFFERLEN
    MOVE BUFFER(1:BUFFERLEN) TO PAYLOAD(PAYLOADLEN + 1:BUFFERLEN)
    ADD BUFFERLEN TO PAYLOADLEN

    *> reduced debug info=false
    ADD 1 TO PAYLOADLEN
    MOVE FUNCTION CHAR(1) TO PAYLOAD(PAYLOADLEN:1)

    *> enable respawn screen=true
    ADD 1 TO PAYLOADLEN
    MOVE FUNCTION CHAR(1) TO PAYLOAD(PAYLOADLEN:1)

    *> do limited crafting=false
    ADD 1 TO PAYLOADLEN
    MOVE FUNCTION CHAR(1) TO PAYLOAD(PAYLOADLEN:1)

    *> dimension type="minecraft:overworld"
    ADD 1 TO PAYLOADLEN
    MOVE FUNCTION CHAR(19 + 1) TO PAYLOAD(PAYLOADLEN:1)
    MOVE "minecraft:overworld" TO PAYLOAD(PAYLOADLEN + 1:19)
    ADD 19 TO PAYLOADLEN

    *> dimension name="minecraft:overworld"
    ADD 1 TO PAYLOADLEN
    MOVE FUNCTION CHAR(19 + 1) TO PAYLOAD(PAYLOADLEN:1)
    MOVE "minecraft:overworld" TO PAYLOAD(PAYLOADLEN + 1:19)
    ADD 19 TO PAYLOADLEN

    *> hashed seed=0 (8-byte long)
    MOVE X"0000000000000000" TO PAYLOAD(PAYLOADLEN + 1:8)
    ADD 8 TO PAYLOADLEN

    *> gamemode=1 (creative)
    ADD 1 TO PAYLOADLEN
    MOVE FUNCTION CHAR(2) TO PAYLOAD(PAYLOADLEN:1)

    *> previous gamemode=-1
    ADD 1 TO PAYLOADLEN
    MOVE FUNCTION CHAR(255 + 1) TO PAYLOAD(PAYLOADLEN:1)

    *> is debug=false
    ADD 1 TO PAYLOADLEN
    MOVE FUNCTION CHAR(1) TO PAYLOAD(PAYLOADLEN:1)

    *> is flat=false
    ADD 1 TO PAYLOADLEN
    MOVE FUNCTION CHAR(1) TO PAYLOAD(PAYLOADLEN:1)

    *> has death location=false
    ADD 1 TO PAYLOADLEN
    MOVE FUNCTION CHAR(1) TO PAYLOAD(PAYLOADLEN:1)

    *> portal cooldown=0
    ADD 1 TO PAYLOADLEN
    MOVE FUNCTION CHAR(1) TO PAYLOAD(PAYLOADLEN:1)

    *> Send the packet
    CALL "SendPacket" USING LK-HNDL PACKET-ID PAYLOAD PAYLOADLEN LK-ERRNO
    GOBACK.

END PROGRAM SendPacket-LoginPlay.