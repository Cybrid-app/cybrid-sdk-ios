info_plist="CybridSDKTestApp/Info.plist"

echo "Setting Client ID"

# Check to see if the value exists in the plist
val1=$(/usr/libexec/PlistBuddy -c 'print :CybridClientId' "${info_plist}" 2>/dev/null);

# Capture exit code
exitCode=$?

if [ $exitCode == 0 ]
    then
    echo "CybridClientId Key already set to '${val1}'";

    else
    echo "Adding key CybridClientId as '${CYB_CLIENT_ID}'"
    /usr/libexec/PlistBuddy -c 'Add CybridClientId string "'${CYB_CLIENT_ID}'"' "${info_plist}";
fi

echo "Setting Client Secret"

# Check to see if the value exists in the plist
val2=$(/usr/libexec/PlistBuddy -c 'print CybridClientSecret' "${info_plist}" 2>/dev/null);

# Capture exit code
exitCode=$?

if [ $exitCode == 0 ]
    then
        echo "CybridClientSecret Key already set to '${val2}'";

    else
    echo "Adding key CybridClientSecret as '${CYB_CLIENT_SECRET}'"
    /usr/libexec/PlistBuddy -c 'Add CybridClientSecret string "'${CYB_CLIENT_SECRET}'"' "${info_plist}";
fi
