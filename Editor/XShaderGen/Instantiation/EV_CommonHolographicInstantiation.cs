using System.Collections.Generic;
using UnityEngine;
#if XRP_SHADER_INSTANTIATION_META
{
    "ClassName": "EV_CommonHolographicShader",
    "Name": "XRender/Environment/CommonHolographic",
    "OutputPath": "Assets/Res/Shader/SurfaceShaderLibrary/EV_CommonHolographic.shader",
    "MM": "CommonHolographic",
    "SM": "SHADING_MODEL_STANDARD_PBR",
    "Owner": "QP4B",
    "Usage": "Environment",
    "Desc": "A Common Holographic Effect",
    "PMs": [],
    "Config": [
        "SetSurfaceType(SurfaceShaderConfig.SurfaceTypeOption.Transparent)",
        "SetOptionTransQueue(SurfaceShaderConfig.TransQueue.PreTrans)",
        "SetAlphaBlendMode(SurfaceShaderConfig.BlendModeOption.Alpha)",
        "SetOptionCullMode(SurfaceShaderConfig.CullModeOption.Option)",
        "SetOptionAlphaCutoffEnable(ShaderOptionFlag.OptionalDisable)",
        "SetOptionZWrite(ShaderOptionFlag.AlwaysDisable)",
        "SetOptionTransparentZWrite(ShaderOptionFlag.OptionalDisable)",
        "SetOptionRefraction(ShaderOptionFlag.AlwaysDisable)",
        "SetSupportDotsInstancing(false)"
    ]
}
#endif

namespace UnityEditor.XRender.XShaderGen.Instantiation
{
    [SurfaceShaderInstantiationAttribute]
    public class EV_CommonHolographicShader : XSurfaceShader
    {
        public override string GetName() => "XRender/Environment/CommonHolographic";
        public override string GetOwner() => "QP4B";
        public override string GetDesc() => "A Common Holographic Effect";
        public override SurfaceShaderUsage GetUsage() => SurfaceShaderUsage.Environment;
        public override string GetGenerateShaderPath() => "Assets/Res/Shader/SurfaceShaderLibrary/EV_CommonHolographic.shader";
        protected override string GetMaterialModelName() => "CommonHolographic";
        protected override string GetShadingModelName() => "SHADING_MODEL_EMISSIVE";
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
            config.SetOptionTransparentResponsiveAA(ShaderOptionFlag.OptionalDisable);
            config.SetOptionSupportDecal(ShaderOptionFlag.AlwaysDisable);
            config.SetOptionDecalLayer(SurfaceShaderConfig.DecalLayer.Layer1);
        }
    }
}
//ss:[[-129182164]]

