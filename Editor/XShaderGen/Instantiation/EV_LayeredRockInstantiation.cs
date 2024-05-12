using System.Collections.Generic;
using UnityEngine;
#if XRP_SHADER_INSTANTIATION_META
{
    "ClassName": "EV_LayeredRock",
    "Name": "XRender/Environment/LayeredSurfaceVariantII",
    "OutputPath": "Assets/Res/Shader/SurfaceShaderLibrary/EV_LayeredRock.shader",
    "MM": "EV_LayeredRock",
    "SM": "SHADING_MODEL_STANDARD_PBR",
    "Owner": "QP4B",
    "Usage": "Environment",
    "Desc": "HeightBlendTest",
    "PMs": [],
    "Config": [
        "SetSurfaceType(SurfaceShaderConfig.SurfaceTypeOption.Option)",
        "SetOptionTransQueue(SurfaceShaderConfig.TransQueue.Option)",
        "SetAlphaBlendMode(SurfaceShaderConfig.BlendModeOption.Option)",
        "SetOptionCullMode(SurfaceShaderConfig.CullModeOption.Option)",
        "SetOptionAlphaCutoffEnable(ShaderOptionFlag.OptionalDisable)",
        "SetOptionZWrite(ShaderOptionFlag.OptionalEnable)",
        "SetOptionTransparentZWrite(ShaderOptionFlag.OptionalDisable)",
        "SetOptionRefraction(ShaderOptionFlag.OptionalDisable)",
        "SetSupportDotsInstancing(true)"
    ]
}
#endif

namespace UnityEditor.XRender.XShaderGen.Instantiation
{
    [SurfaceShaderInstantiationAttribute]
    public class EV_LayeredRock : XSurfaceShader
    {
        public override string GetName() => "XRender/Environment/EV_LayeredRock";
        public override string GetOwner() => "QP4B";
        public override string GetDesc() => "Layered Rock In Editor";
        public override SurfaceShaderUsage GetUsage() => SurfaceShaderUsage.Environment;
        public override string GetGenerateShaderPath() => "Assets/Res/Shader/SurfaceShaderLibrary/EV_LayeredRock.shader";
        protected override string GetMaterialModelName() => "EV_LayeredRock";
        protected override string GetShadingModelName() => "SHADING_MODEL_STANDARD_PBR";
        protected override List<PluginModelDesc> InitPluginModelDescs() => new()
        {
            new PluginModelDesc {name = "TilingLayer", needMultiCompile = true},
            new PluginModelDesc {name = "TilingLayer_R", needMultiCompile = true},
            new PluginModelDesc {name = "TilingLayer_G", needMultiCompile = true},
            new PluginModelDesc {name = "AdditionalLayer", needMultiCompile = true},
            // Blend Base Layer
            new PluginModelDesc {name = "BaseLayer", needMultiCompile = false, displayPriority = -1},
            new PluginModelDesc {name = "DetailLayer", needMultiCompile = true},
            // Topping
            new PluginModelDesc {name = "ToppingLayer", needMultiCompile = true},
        };
        protected override void AdditionalConfig(SurfaceShaderConfig config)
        {
            config.SetSurfaceType(SurfaceShaderConfig.SurfaceTypeOption.Opaque);
            config.SetOptionTransQueue(SurfaceShaderConfig.TransQueue.Trans);
            config.SetAlphaBlendMode(SurfaceShaderConfig.BlendModeOption.Alpha);
            config.SetOptionCullMode(SurfaceShaderConfig.CullModeOption.Back);
            config.SetOptionAlphaCutoffEnable(ShaderOptionFlag.AlwaysDisable);
            config.SetOptionZWrite(ShaderOptionFlag.AlwaysEnable);
            config.SetOptionTransparentZWrite(ShaderOptionFlag.AlwaysDisable);
            config.SetOptionRefraction(ShaderOptionFlag.AlwaysDisable);
            config.SetSupportDotsInstancing(true);
        }
    }
}
//ss:[[-1516735531]]

