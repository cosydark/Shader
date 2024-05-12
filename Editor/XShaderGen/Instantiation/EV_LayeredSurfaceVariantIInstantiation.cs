using System.Collections.Generic;
using UnityEngine;
#if XRP_SHADER_INSTANTIATION_META
{
    "ClassName": "EV_LayeredSurfaceShader",
    "Name": "XRender/Environment/LayeredSurfaceVariantI",
    "OutputPath": "Assets/Res/Shader/SurfaceShaderLibrary/EV_LayeredSurfaceVariantI.shader",
    "MM": "LayeredSurfaceVariantI",
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
    public class EV_LayeredSurfaceVariantI : XSurfaceShader
    {
        public override string GetName() => "XRender/Environment/LayeredSurfaceVariantI";
        public override string GetOwner() => "QP4B";
        public override string GetDesc() => "";
        public override SurfaceShaderUsage GetUsage() => SurfaceShaderUsage.Environment;
        public override string GetGenerateShaderPath() => "Assets/Res/Shader/SurfaceShaderLibrary/EV_LayeredSurfaceVariantI.shader";
        protected override string GetMaterialModelName() => "LayeredSurfaceVariantI";
        protected override string GetShadingModelName() => "SHADING_MODEL_STANDARD_PBR";
        protected override List<PluginModelDesc> InitPluginModelDescs() => new()
        {
            // new PluginModelDesc {name = "DefaultPluginModel", needMultiCompile = false},
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

