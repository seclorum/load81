export PROGRAM=load81
export OUTPUTPATH=/tmp/load81/bundle/ 
export BUNDLE=$OUTPUTPATH/$PROGRAM.app 
mkdir -p $BUNDLE/Contents 
mkdir -p $BUNDLE/Contents/MacOS 
mkdir -p $BUNDLE/Contents/Resources 
mkdir -p $BUNDLE/Contents/Frameworks 

#Copy frameworks like SDL: 

cp -RH /Library/Frameworks/SDL2.framework $BUNDLE/Contents/Frameworks/ 
rm -fr $BUNDLE/Contents/Frameworks/SDL2.framework/Versions/A/Headers/ 
rm -fr $BUNDLE/Contents/Frameworks/SDL2.framework/Headers 

#Copy assets, icon file, Info.plist, etc., into resources folder: 

cp -rfv examples/ $BUNDLE/Contents/Resources 
#cp -f $ICONFILE $BUNDLE/Contents/Resources/$ICONFILE 
cp Info.plist $BUNDLE/Contents/Resources 

#Create the executable from your object files and place in MacOS directory: 
cp load81 $BUNDLE/Contents/MacOS/$PROGRAM

#Change resource path of SDL not sure why but this is necessary: 

install_name_tool -change @rpath/SDL2.framework/Versions/A/SDL2 @executable_path/../Frameworks/SDL2.framework/Versions/A/SDL2 $BUNDLE/Contents/MacOS/$PROGRAM 

#Codesign entitlements if necessary: 

codesign -f -v -s "3rd Party Mac Developer Application: load81" "$BUNDLE/Contents/Frameworks/SDL2.framework/Versions/A/SDL2"	
codesign -f -v -s "3rd Party Mac Developer Application: load81" --entitlements entitlements.plist "$BUNDLE" 

#Create pkg file: 
MASPKGFILENAME=$PROGRAM-$PROGVER.pkg 
cd $OUTPUTPATH && productbuild --component "load81" /Applications --sign "3rd Party Mac Developer Installer: load81" "$MASPKGFILENAME" 

