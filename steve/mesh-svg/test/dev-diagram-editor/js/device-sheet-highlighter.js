//..............................................................................

var svg             = document    .getElementById        ('pin-layout-diagram');
var elementsNet     = svg         .getElementsByClassName('elements-net'      );
var elementsNoNet   = svg         .getElementsByClassName('no-net'            );
var displayGroup    = svg         .getElementById        ('displayGroup'      );
var crossHairs      = svg         .getElementById        ('crosshairs'        );
var displayTextNet  = displayGroup.getElementsByTagName  ('text'              )[0];
var displayTextRef  = displayGroup.getElementsByTagName  ('text'              )[1];
var displayPad      = displayGroup.getElementsByTagName  ('circle'            )[0];
var captionElement  = svg         .getElementById        ('captionElement'    );
var descElement0    = svg         .getElementById        ('descElement0'      );
var descElement1    = svg         .getElementById        ('descElement1'      );
var textBoxElement  = svg         .getElementById        ('textBoxElement'    );
var outline         = svg         .getElementById        ('outline'           );
var language        = '';
const opacityFaded = 0.4;

var mousePosition   = svg.createSVGPoint();
var matrix          = svg.getScreenCTM();

var parent;
var net = '';

displayTextNet.setAttribute("font-size", "0.35");
displayTextRef.setAttribute("font-size", "0.35");

//..............................................................................

//..............................................................................
const colors =
{
    color__gold      : "#ebb300",
    color__PadDefault: '#c0c0c0',
};
//..............................................................................

//..............................................................................
function getMousePosition(evt)
{
    mousePosition.x = evt.clientX;
    mousePosition.y = evt.clientY;

    return mousePosition.matrixTransform(matrix.inverse());
}
//..............................................................................

//..............................................................................
function setCrossHairsCoords(evt)
{
    crossHairs.setAttribute("x", getMousePosition(evt).x);
    crossHairs.setAttribute("y", getMousePosition(evt).y);
}
//..............................................................................

//..............................................................................
function getStringSplitPoint(s)
{
    var indices = '';
    var middle = s.length/2;

    for (var i = 0; i < s.length; i++)
    {
        if (s[i] === ' ')
        {
            indices = indices + i + ','
        }
    }

    indices = indices.split(',');

    for (i = 0; i < indices.length; i++)
    {
        if (indices[i] > middle)
        {
            return indices[i];
        }
    }
}
//..............................................................................

//..............................................................................
function showHelpText(parent)
{
    var descriptionEn = parent.getAttribute("description_en");
    var descriptionZh = parent.getAttribute("description_zh");
    var captionEn     = parent.getAttribute("caption_en"    );
    var captionZh     = parent.getAttribute("caption_zh"    );

    var splitPoint = getStringSplitPoint(descriptionEn);

    descriptionEn.substring(0, splitPoint);
    descriptionEn.substring(   splitPoint);

    descriptionEn.substring(   splitPoint);

    captionElement.firstChild.data = captionEn;
    descElement1  .firstChild.data = '';

    if (descriptionEn.length > 35)
    {
        descElement0.firstChild.data = descriptionEn.substring(0, splitPoint).trim();
        descElement1.firstChild.data = descriptionEn.substring(   splitPoint).trim();
    }
    else
    {
        descElement0.firstChild.data = descriptionEn.trim();
    }

    var capLength   = captionElement.getComputedTextLength;
    var descLength0 = descElement0  .getComputedTextLength;
    var descLength1 = descElement1  .getComputedTextLength;

    captionElement.setAttribute("x", capLength / 2);
    descElement0  .setAttribute("x", descLength0/2);
    descElement1  .setAttribute("x", descLength1/2);

    captionElement.setAttribute("visibility", "visible");
    descElement0  .setAttribute("visibility", "visible");
    descElement1  .setAttribute("visibility", "visible");
    textBoxElement.setAttribute("visibility", "visible");
}
//..............................................................................

//..............................................................................
function highlightGroupByNet(net)
{
    for(var i = 0; i < elementsNet.length; i++)
    {
        if (elementsNet[i].getAttribute("net") === net)
        {
            elementsNet[i].setAttribute("opacity", "1.0");
            elementsNet[i].setAttribute("visibility", "visible");
        }
    }
}
//..............................................................................

//..............................................................................
function setTargetCoordinates(evt)
{
    var targetTextNet = parent.getElementsByTagName('text'  )[0];
    var targetTextRef = parent.getElementsByTagName('text'  )[1];
    var targetPad     = parent.getElementsByTagName('circle')[0];

    var fillColour = evt.target.parentNode.getAttribute("fill");

    var targetRef = targetTextRef.firstChild.data;

    var targetNetX = targetTextNet.getAttribute("x" );
    var targetRefX = targetTextRef.getAttribute("x" );
    var targetPadX = targetPad    .getAttribute("cx");

    var targetNetY = targetTextNet.getAttribute("y" );
    var targetRefY = targetTextRef.getAttribute("y" );
    var targetPadY = targetPad    .getAttribute("cy");

    displayTextNet.setAttribute("x",  targetNetX);
    displayTextRef.setAttribute("x",  targetRefX);
    displayPad    .setAttribute("cx", targetPadX);

    displayTextNet.setAttribute("y",  targetNetY);
    displayTextRef.setAttribute("y",  targetRefY);
    displayPad    .setAttribute("cy", targetPadY);

    if (fillColour === colors.color__PadDefault)
    {
        displayPad.setAttribute("fill", colors.color__gold);
    }
    else
    {
        displayPad.setAttribute("fill", fillColour);
    }

    displayTextRef.firstChild.data = targetRef;
    displayTextNet.firstChild.data = net;

    getMousePosition(targetPadX, targetPadY);

    crossHairs.setAttribute("x", targetPadX);
    crossHairs.setAttribute("y", targetPadY);
}
//..............................................................................

//..............................................................................
function elementsMouseOver(evt)
{
    parent = evt.target.parentElement;
    net    = parent.getAttribute("net");

    setTargetCoordinates(evt);

    fadeAll();

    parent      .setAttribute("visibility", "hidden");
    displayGroup.setAttribute("visibility", "visible");

    highlightGroupByNet (net);

    showHelpText(parent);
}
//..............................................................................

//..............................................................................
function unFadeAll()
{
    for(var i = 0; i < elementsNet.length; i++)
    {
        elementsNet[i].setAttribute("opacity", "1.0");
        elementsNet[i].setAttribute("visibility", "visible");
    }

    for(i = 0; i < elementsNoNet.length; i++)
    {
        elementsNoNet[i].setAttribute("opacity", "1.0");
        elementsNoNet[i].setAttribute("visibility", "visible");
    }
}
//..............................................................................

//..............................................................................
function fadeAll()
{
    for(i = 0; i < elementsNet.length; i++)
    {
        elementsNet[i].setAttribute("opacity", opacityFaded);
    }

    for(i = 0; i < elementsNoNet.length; i++)
    {
        elementsNoNet[i].setAttribute("opacity", opacityFaded);
    }
}
//..............................................................................

//..............................................................................
function sleep(milliseconds)
{
    var start = new Date().getTime();

    for (var i = 0; i < 1e7; i++)
    {
        if ((new Date().getTime() - start) > milliseconds)
        {
            break;
        }
    }
}
//..............................................................................

//..............................................................................
function hideHelpText(evt)
{
    if (parent === evt.target.parentElement)
    {
        return;
    }

    unFadeAll();

    parent  .setAttribute("visibility", "visible");

    sleep(200);
}
//..............................................................................

//..............................................................................
function showParent()
{
    sleep(200);

    parent.setAttribute("visibility", "visible");
}
//..............................................................................

//..............................................................................
function miscMouseMove(evt)
{
    setCrossHairsCoords(evt);

    unFadeAll();

    sleep(200);

    captionElement.setAttribute("visibility", "hidden");
    descElement0  .setAttribute("visibility", "hidden");
    descElement1  .setAttribute("visibility", "hidden");
    displayGroup  .setAttribute("visibility", "hidden");
}
//..............................................................................

//..............................................................................
function elementsNoNetMouseMove(evt)
{
    setCrossHairsCoords(evt);
}
//..............................................................................

//..............................................................................

svg.addEventListener('load'    , hideHelpText);

outline .addEventListener('mousemove', miscMouseMove);

displayTextNet.addEventListener('mousemove', showParent);

captionElement.addEventListener('mousemove', elementsNoNetMouseMove);
descElement0  .addEventListener('mousemove', elementsNoNetMouseMove);
descElement1  .addEventListener('mousemove', elementsNoNetMouseMove);
textBoxElement.addEventListener('mousemove', elementsNoNetMouseMove);

for (var i = 0; i < elementsNet.length; i++)
{
    elementsNet[i].addEventListener('mouseover', elementsMouseOver);
    elementsNet[i].addEventListener('mouseout' , hideHelpText);
}

for (i = 0; i < elementsNoNet.length; i++)
{
    elementsNoNet[i].addEventListener('mouseover', elementsNoNetMouseMove);
}
//..............................................................................

//..............................................................................
