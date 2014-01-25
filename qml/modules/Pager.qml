import QtQuick 2.0
import Sailfish.Silica 1.0

Item {

   id: root

   //inputs
   property bool isHorizontal: false
   property bool hardEdges: false
   property bool useTouchMask: false

   property int startIndex

   property var model
   property Component delegate

   //outputs
   property int indexNow: lister.currentIndex
   property int previousIndex

   property Item itemNow: lister.currentItem

   property int count: lister.count

   property alias interactive: lister.interactive

   property string placeholderText

//   property real indicatorFading: lister.indOpa

   ListView {

       id: lister
       anchors.fill: root

       orientation: root.isHorizontal ?
                        ListView.Horizontal :
                            ListView.Vertical

       flickableDirection: root.isHorizontal ?
                               Flickable.HorizontalFlick :
                               Flickable.VerticalFlick

       boundsBehavior: root.hardEdges ?
                           Flickable.StopAtBounds :
                                Flickable.DragAndOvershootBounds

       clip: true

       snapMode: ListView.SnapOneItem

       highlightFollowsCurrentItem: true
       highlightRangeMode: ListView.StrictlyEnforceRange

       preferredHighlightBegin: 0
       preferredHighlightEnd: 0
       cacheBuffer: width;

       highlightMoveDuration: 500

       flickDeceleration: 500

       currentIndex: root.startIndex

       model: root.model
       delegate: root.delegate

       Component.onCompleted: {
           lister.currentIndex = root.startIndex;
           lister.positionViewAtIndex(root.startIndex, ListView.Contain);

       }

//       MouseArea {
//           id: stealPreventer
//           anchors.fill: parent
//           preventStealing: root.useTouchMask
//           propagateComposedEvents: root.useTouchMask
//       }

//       property real indOpa: 1


//       Behavior on contentX {
//           NumberAnimation {
//               properties: "indOpa"
//               from: 0.75
//               to: 1
//               duration: 1000 }

//        }

   }

   ViewPlaceholder {
        enabled: lister.count === 0
        text: root.placeholderText
        anchors.centerIn: parent
   }

   function moveToPage(index)
   {
       //console.log(root.objectName + ": Moved from " + lister.currentIndex + " to page " + index);
      // lister.positionViewAtIndex(index, ListView.Contain);
       lister.currentIndex = index;
   }
   function showPage(index)
   {
       lister.positionViewAtIndex(index, ListView.Contain);
   }
}

