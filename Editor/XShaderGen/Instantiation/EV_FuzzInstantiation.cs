using System.Collections.Generic;
using UnityEngine;
#if XRP_SHADER_INSTANTIATION_META
{
    "ClassName": "EV_FuzzShader",
    "Name": "XRender/Environment/Fuzz",
    "OutputPath": "Assets/Res/Shader/SurfaceShaderLibrary/EV_Fuzz.shader",
    "MM": "EV_Fuzz",
    "SM": "SHADING_MODEL_FABRIC",
    "Owner": "QP4B",
    "Usage": "Environment",
    "Desc": "EV Fuzz",
    "PMs": [],
    "Config": [
        "SetSurfaceType(SurfaceShaderConfig.SurfaceTypeOption.Option)",
        "SetOptionTransQueue(SurfaceShaderConfig.TransQueue.Option)",
        "SetAlphaBlendMode(SurfaceShaderConfig.BlendModeOption.Option)",
        "SetOptionCullMode(SurfaceShaderConfig.CullModeOption.Option)",
        "SetOptionAlphaCutoffEnable(ShaderOptionFlag.OptionalDisable)",
        "SetOptionZWrite(ShaderOptionFlag.AlwaysEnable)"
    ]
}
#endif

namespace UnityEditor.XRender.XShaderGen.Instantiation
{
    [SurfaceShaderInstantiationAttribute]
    public class EV_FuzzShader : XSurfaceShader
    {
        public override string GetName() => "XRender/Environment/Fuzz";
        public override string GetOwner() => "QP4B";
        public override string GetDesc() => "EV Fuzz";
        public override SurfaceShaderUsage GetUsage() => SurfaceShaderUsage.Environment;
        public override string GetGenerateShaderPath() => "Assets/Res/Shader/SurfaceShaderLibrary/EV_Fuzz.shader";
        protected override string GetMaterialModelName() => "EV_Fuzz";
        protected override string GetShadingModelName() => "SHADING_MODEL_FABRIC";
        protected override List<PluginModelDesc> InitPluginModelDescs() => new()
        {
            new PluginModelDesc { name = "WinterSuite", needMultiCompile = true},
        };
        protected override void AdditionalConfig(SurfaceShaderConfig config)
        {
            config.SetSurfaceType(SurfaceShaderConfig.SurfaceTypeOption.Option);
            config.SetOptionTransQueue(SurfaceShaderConfig.TransQueue.Option);
            config.SetAlphaBlendMode(SurfaceShaderConfig.BlendModeOption.Option);
            config.SetOptionCullMode(SurfaceShaderConfig.CullModeOption.Option);
            config.SetOptionAlphaCutoffEnable(ShaderOptionFlag.OptionalDisable);
            config.SetOptionZWrite(ShaderOptionFlag.AlwaysEnable);
        }
    }
}
//ss:[[-1856473290]]

