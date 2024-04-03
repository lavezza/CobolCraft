IDENTIFICATION DIVISION.
PROGRAM-ID. SendPacket-LoginDisconnect.

DATA DIVISION.
WORKING-STORAGE SECTION.
    01 PACKET-ID    PIC 9(10)       VALUE 0.
    *> buffer used to store the JSON string
    01 JSONBUFFER   PIC X(64000).
    01 JSONPOS      PIC 9(5).
    *> temporary data used during encoding
    01 INT32        PIC S9(10).
    01 STR          PIC X(1000).
    01 STRLEN       PIC 9(5).
    *> buffer used to store the packet data
    01 PAYLOAD      PIC X(64000).
    01 PAYLOADLEN   PIC 9(5).
LINKAGE SECTION.
    01 LK-HNDL      PIC X(4).
    01 LK-ERRNO     PIC 9(3).
    01 LK-REASON    PIC X(1000).
    01 LK-REASONLEN PIC 9(5).

PROCEDURE DIVISION USING BY REFERENCE LK-HNDL LK-ERRNO LK-REASON LK-REASONLEN.
    *> Encode the JSON payload {"text":"<reason>"}
    MOVE 1 TO JSONPOS
    CALL "JsonEncode-ObjectStart" USING JSONBUFFER JSONPOS
    MOVE "text" TO STR
    MOVE 4 TO STRLEN
    CALL "JsonEncode-ObjectKey" USING JSONBUFFER JSONPOS STR STRLEN
    MOVE LK-REASON TO STR
    MOVE LK-REASONLEN TO STRLEN
    CALL "JsonEncode-String" USING JSONBUFFER JSONPOS STR STRLEN
    CALL "JsonEncode-ObjectEnd" USING JSONBUFFER JSONPOS

    *> Build the payload: VarInt (JSON length) + JSON
    COMPUTE INT32 = JSONPOS - 1
    CALL "Encode-VarInt" USING INT32 PAYLOAD PAYLOADLEN
    MOVE JSONBUFFER TO PAYLOAD(PAYLOADLEN + 1:JSONPOS)
    ADD INT32 TO PAYLOADLEN

    *> Send the packet
    CALL "SendPacket" USING LK-HNDL PACKET-ID PAYLOAD PAYLOADLEN LK-ERRNO.

END PROGRAM SendPacket-LoginDisconnect.