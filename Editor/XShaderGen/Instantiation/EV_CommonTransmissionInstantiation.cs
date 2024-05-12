using System.Collections.Generic;
using UnityEngine;
#if XRP_SHADER_INSTANTIATION_META
{
    "ClassName": "EV_CommonTransmissionShader",
    "Name": "XRender/Environment/CommonTransmission",
    "OutputPath": "Assets/Res/Shader/SurfaceShaderLibrary/EV_CommonTransmission.shader",
    "MM": "CommonTransmission",
    "SM": "SHADING_MODEL_STANDARD_PBR",
    "Owner": "QP4B",
    "Usage": "Environment",
    "Desc": "A Common Transmission Material",
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
    public class EV_CommonTransmissionShader : XSurfaceShader
    {
        public override string GetName() => "XRender/Environment/CommonTransmission";
        public override string GetOwner() => "QP4B";
        public override string GetDesc() => "A Common Transmission Material";
        public override SurfaceShaderUsage GetUsage() => SurfaceShaderUsage.Environment;
        public override string GetGenerateShaderPath() => "Assets/Res/Shader/SurfaceShaderLibrary/EV_CommonTransmission.shader";
        protected override string GetMaterialModelName() => "CommonTransmission";
        protected override string GetShadingModelName() => "SHADING_MODEL_STANDARD_PBR";
        protected override List<PluginModelDesc> InitPluginModelDescs() => new()
        {
            // new PluginModelDesc {name = "DefaultPluginModel", needMultiCompile = false},
        };
        protected override void AdditionalConfig(SurfaceShaderConfig config)
        {
            config.SetSurfaceType(SurfaceShaderConfig.SurfaceTypeOption.Option);
            config.SetOptionTransQueue(SurfaceShaderConfig.TransQueue.Option);
            config.SetAlphaBlendMode(SurfaceShaderConfig.BlendModeOption.Option);
            config.SetOptionCullMode(SurfaceShaderConfig.CullModeOption.Option);
            config.SetOptionAlphaCutoffEnable(ShaderOptionFlag.OptionalDisable);
            config.SetOptionZWrite(ShaderOptionFlag.OptionalEnable);
            config.SetOptionTransparentZWrite(ShaderOptionFlag.OptionalDisable);
            config.SetOptionRefraction(ShaderOptionFlag.OptionalDisable);
        }
    }
}
//ss:[[-901051071]]

