import QtQuick
import Qt5Compat.GraphicalEffects
import "../theme"

Item {
    id: root
    anchors.fill: parent

    // Properties to tweak the look
    property real cornerRadius: 40
    property real opacityTint: 0.6  // How much Gruvbox color to show (0.0 - 1.0)
    property real noiseOpacity: 0.08 // How grainy it looks

    // 1. The Mask (Defines the shape)
    Rectangle {
        id: maskRect
        anchors.fill: parent
        radius: root.cornerRadius
        visible: false
    }

    // 2. The Content Wrapper (Clipped to the Mask)
    Item {
        anchors.fill: parent
        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: maskRect
        }

        // A. The Background Tint (Gruvbox Color with Transparency)
        Rectangle {
            anchors.fill: parent
            // This mixes your Theme background with transparency
            color: Qt.rgba(Theme.background.r, Theme.background.g, Theme.background.b, root.opacityTint)
        }

        // B. The Noise Shader (The grainy texture)
        ShaderEffect {
            anchors.fill: parent
            opacity: root.noiseOpacity
            
            // Standard one-liner noise generator
            fragmentShader: "
                varying highp vec2 qt_TexCoord0;
                uniform highp float qt_Opacity;
                void main() {
                    highp vec2 uv = qt_TexCoord0;
                    highp float noise = fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453);
                    // Output white noise
                    gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0) * noise * qt_Opacity;
                }
            "
        }
    }

    // 3. The Border (Drawn on top for crispness)
    Rectangle {
        anchors.fill: parent
        radius: root.cornerRadius
        color: "transparent"
        border.color: Theme.border
        border.width: 2
        // Optional: Make border slightly transparent to blend better
        opacity: 0.5 
    }
}
