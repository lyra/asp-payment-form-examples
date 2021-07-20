<!--
/**
 * Copyright © Lyra Network.
 * This file is part of Lyra ASP payment form example. See COPYING.md for license details.
 *
 * @author    Lyra Network <https://www.lyra.com>
 * @copyright Lyra Network
 * @license   http://www.gnu.org/licenses/gpl.html GNU General Public License (GPL v3)
 */
-->

<%
'******************************************************************************************
' Include Crypto JS library to use SHA1 and HMAC-SHA256 algorithms.
'******************************************************************************************
%>

<SCRIPT LANGUAGE="JScript" RUNAT="Server" src="js/sha1.js"></SCRIPT>
<SCRIPT LANGUAGE="JScript" RUNAT="Server" src="js/hmac-sha256.js"></SCRIPT>
<SCRIPT LANGUAGE="JScript" RUNAT="Server" src="js/base64.js"></SCRIPT>

<SCRIPT LANGUAGE="JScript" RUNAT="Server">

var Hash = {}; // Hash namespace.

Hash.hmacSha256 = function(msg, key) {
    return CryptoJS.HmacSHA256(msg, key).toString(CryptoJS.enc.Base64);
};

Hash.sha1 = function(msg) {
    return CryptoJS.SHA1(msg);
}

/*
 * Function that returns UNIX timestamp of the current date.
 */
function getCurrentTime() {
    var date = new Date();
    return date.valueOf();
}

/*
 * Function that converts date to UTC and formats it as 'yyyyMMddhhmmss'.
 */
function formatDate(timestamp) {
    var date = new Date(timestamp);

    var str = '';
    str += padLeft(date.getUTCFullYear(), 4);
    str += padLeft(date.getUTCMonth() + 1, 2);
    str += padLeft(date.getUTCDate(), 2);
    str += padLeft(date.getUTCHours(), 2);
    str += padLeft(date.getUTCMinutes(), 2);
    str += padLeft(date.getUTCSeconds(), 2);

    return str;
}

/*
 * Function that calculates a transaction ID as the number of 1/10 seconds since midnight.
 */
function generateTransId(timestamp) {
    var curDay = new Date(timestamp);
    curDay.setHours(0);
    curDay.setMilliseconds(0);
    curDay.setMinutes(0);
    curDay.setSeconds(0);

    var temp = timestamp - curDay.valueOf(); // Number of milliseconds since midnight.
    temp = parseInt(temp / 100);

    return padLeft(temp, 6);
}

/*
 * Function that adds zeros until 'number' has 'length' positions.
 */
function padLeft(number, length) {
    var str = '' + number;
    while (str.length < length) {
        str = '0' + str;
    }

    return str;
}

</SCRIPT>

<%
'******************************************************************************************
' Function for sorting array of value strings according to alphabetical order of their keys.
' arrInt: array of keys
' arrInt2: array of values
' return an array of sorted values
'******************************************************************************************
function BubbleSort(arrInt, arrInt2)
    for i = UBound(arrInt) - 1 To 0 Step -1
        for j = 0 to i
            if StrComp(arrInt(j), arrInt(j+1), 1) = 1 then
                temp = arrInt(j+1)
                temp2 = arrInt2 (j+1)
                arrInt(j+1) = arrInt(j)
                arrInt2(j+1) = arrInt2(j)
                arrInt(j) = temp
                arrInt2(j) = temp2
            end if
        next
    next

    BubbleSort = arrInt2
end function

'***********************************************************************
' Encode input string to UTF-8.
' s: An ISO-8859 encoded string
' Return an UTF-8 encoded string
'***********************************************************************
function EncodeUTF8(s)
    dim i
    dim c

    i = 1
    do while i <= len(s)
        c = asc(mid(s, i, 1))
        if c >= &H80 then
            s = left(s,i-1) + chr(&HC2 + ((c and &H40) / &H40)) + chr(c and &HBF) + mid(s,i+1)
            i = i + 1
        end if
        i = i + 1
    loop

    EncodeUTF8 = s
end function

'***********************************************************************
' Encode input string to ISO-8859.
' s: An UTF-8 encoded string
' Return an ISO-8859 encoded string
'***********************************************************************
function DecodeUTF8(s)
    dim i
    dim c
    dim n

    i = 1
    do while i <= len(s)
        c = asc(mid(s, i, 1))
        if c and &H80 then
            n = 1
            do while i + n < len(s)
                if (asc(mid(s,i+n,1)) and &HC0) <> &H80 then
                    exit do
                end if
                n = n + 1
            loop

            if n = 2 and ((c and &HE0) = &HC0) then
                c = asc(mid(s,i+1,1)) + &H40 * (c and &H01)
            else
                c = 191
            end if

            s = left(s,i-1) + chr(c) + mid(s,i+n)
        end if

        i = i + 1
    loop

    DecodeUTF8 = s
end function
%>